-- Variables
--- populates QBCore table
local QBCore = exports['qb-core']:GetCoreObject()
--- NUI Vehicle Button List Table
local vehBtnList = {}
--- NUI Boss Menu Button List Table
local mgrBtnList = {
    ["players"] = {},
    ["jobs"] = {}
}
local printColors = {
    --[[ Color Notes
        ["black"] = "^0",
        ["red"] = "^1",
        ["green"] = "^2",
        ["yellow"] = "^3",
        ["blue"] = "^4",
        ["lightBlue"] = "^5",
        ["purple"] = "^6",
        ["white"] = "^7",
        ["orange"] = "^8",
        ["grey"] = "^9"
    ]]--
    ["error"] = {
        ["console"] = "^1",
        ["log"] = "red"
    },
    ["success"] = {
        ["console"] = "^2",
        ["log"] = "green"
    },
    ["notice"] = {
        ["console"] = "^4",
        ["log"] = "blue"
    },
    ["exploit"] = {
        ["console"] = "^8",
        ["log"] = "orange"
    },
}
--- Counts Number of Vehicles a given Job has assigned.
local vehCount = {}
--- Tracks all vehicles spawned by players
local vehTrack = {}
--- key is the job name and value is the job label
-- local jobsList = {}
--- Populates  the server side QBCore.Shared.Jobs table at resource start
exports['qb-core']:AddJobs(Config.Jobs)
-- Functions
local function errorHandler(error)
    local pcolor = "^1"
    local jsMsg = {}
    for _,v in pairs(error) do
        if v.notify then TriggerClientEvent('QBCore:Notify', v.src, v.msg) end
        if v.log then TriggerEvent('qb-log:server:CreateLog', v.logName, v.subject, printColors[v.color].log, v.msg) end
        if v.console then
            if printColors[v.color] then pcolor = printColors[v.color].console end
            v.msg = pcolor .. v.msg
            print(v.msg)
        end
        if v.kick then DropPlayer(src, v.msg) end
        if v.ban then exports["qb-adminmenu"]:BanPlayer(v.src) end
        if v.jsMsg then jsMsg[#jsMsg+1] = v.jsMsg end
    end
    return jsMsg
end
--- Populates the server side QBCore.Shared.Jobs table
local function populateJobs(src)
    CreateThread(function()
        exports['qb-core']:AddJobs(Config.Jobs)
        for k,v in pairs(Config.Jobs) do
            TriggerClientEvent('QBCore:Client:OnSharedUpdate', src, "Jobs", k, v)
        end
    end)
end
exports('populateJobs',populateJobs)
local sendWebHooks = function()
    for k,v in pairs(Config.Jobs) do
        if v.webHooks then
            exports['qb-smallresources']:addToWebhooks(v.webHooks)
        end
    end
end
--- Checks if underling is online
local function setUnderlingStatus(res)
    local src = res.src
    local citid = res.citid
    local data = {
        ["isOnline"] = false,
        ["error"] = {},
        ["success"] = {}
    }
    local ercnt = 0
    if src then
        data.player = QBCore.Functions.GetPlayer(src)
    elseif citid then
        data.player = QBCore.Functions.GetPlayerByCitizenId(citid)
    end
    if data.player then data.isOnline = true end
    if not data.isOnline then
        data.player = QBCore.Player.GetOfflinePlayer(citid)
        data.isOnline = false
    end
    if not data.player then
        data.error[ercnt] = {
            ["subject"] = "Player Does Not Exist!",
            ["msg"] = string.format("player does not exist in setUnderlingStatus! #msg001"),
            ["jsMsg"] = "Player Does Not Exist!",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(data.error)
        return data
    end
    return data
end
--- Prepares data for the buildJobHistory function for the current player
local function processJobHistory(jhData)
    --- Builds the Job History metadata table.
    local function buildJobHistory(res)
        local jobName = res.job
        if jobName == "unemployed" then return "false" end
        local jobData
        local jobHistory = {}
        if res.player.PlayerData.metadata.jobhistory then jobHistory = res.player.PlayerData.metadata.jobhistory end
        local jhList = {
            ["status"] = "available",
            ["rehireable"] = true,
            ["reprimands"] = {},
            ["awards"] = {},
            ["details"] = {},
            ["grades"] = {},
            ["gradechangecount"] = 0,
            ["firedcount"] = 0,
            ["hiredcount"] = 0,
            ["quitcount"] = 0,
            ["denycount"] = 0,
            ["applycount"] = 0
        }
        local index = {
            ["reprimands"] = 1,
            ["awards"] = 1,
            ["details"] = 1,
            ["grades"] = 1
        }
        for k in pairs(Config.Jobs) do
            if not jobHistory[k] then
                jobHistory[k] = jhList
                if k == "unemployed" then jobHistory[k] = nil end
            end
        end
        if jobHistory["unemployed"] then jobHistory["unemployed"] = nil end
        jobData = jobHistory[jobName]
        for kp,vp in pairs(jhList) do
            if type(vp) == "table"  then
                if res[res.job][kp] then
                    if jobData[kp] then
                        for _ in pairs(jobData[kp]) do
                            index[kp] += 1
                        end
                    end
                    if index[kp] == 0 then index[kp] = 1 end
                    for _,v in pairs(res[res.job][kp]) do
                        jobData[kp][index[kp]] = v
                        index[kp] += 1
                    end
                end
            elseif type(vp) == "number" then
                if not res[res.job][kp] then res[res.job][kp] = 0 end
                jobData[kp] += res[res.job][kp]
            elseif kp == "status" then
                if res[res.job][kp] then jobData[kp] = res[res.job][kp] end
            end
        end
        if jobName == "unemployed" then jobData = nil end
        return jobData
    end
    local data,jobHistory
    if not jhData.player then
        data = setUnderlingStatus(jhData)
        jhData.isOnline = data.isOnline
        jhData.player = data.player
    end
    if not jhData.player then return data end
    local ercnt = 0
    jhData.error = {}
    jhData.success = {}
    if not Config.Jobs[jhData.job] then
        jhData.error[ercnt] = {
            ["subject"] = "Job Does Not Exist",
            ["msg"] = "Job Does Not Exist in processJobHistory, msg001",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(jhData.error)
        return "failed"
    end
    jobHistory = buildJobHistory(jhData)
    return jobHistory
end
exports("processJobHistory",processJobHistory)
--- Saves the online & offline playerData

--- Sets the job up for the underling
local function setJob(res)
    local data = setUnderlingStatus(res)
    if data.error and next(data.error) then return data end
    local prevJob = res.prevJob:lower() -- Manager's Job
    local newJob = res.newJob:lower() -- Employee's New Job
    local grade = tostring(res.grade) -- Employee's Grade
    local job = res.job:lower() -- Manager's Job
    local citid = res.citid -- Employee's Citizen ID
    local metaData = data.player.PlayerData.metadata
    data.job = job
    data[job] = res[job]
    data.jobs = metaData.jobs
    data.jobhistory = metaData.jobhistory
    local jobs = metaData.jobs
    local src = res.src -- Manager's Source
    local ercnt = 0
    local player = data.player
    local jobGrade, queryResult
    local pD = {
        ["job"] = {},
        ["citid"] = res.citid
    }
    local jobHistory = processJobHistory(data)
    if not Config.Jobs[res.job] then
        data.error[ercnt] = {
            ["subject"] = "Job does not exist!",
            ["msg"] = string.format("%s attempted to set a job that didn't exist in processJobHistory msg#003", player.PlayerData.license),
            ["jsMsg"] = "Job does not exist!",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(data.error)
        return data
    end
    if data.isOnline then
        player.Functions.SetJob(newJob, grade)
        player = QBCore.Functions.GetPlayerByCitizenId(citid)
        player.Functions.AddToJobHistory(prevJob,jobHistory)
        player.Functions.AddToJobs(prevJob, nil)
        player.Functions.AddToJobs(player.PlayerData.job.name, player.PlayerData.job)
        player = QBCore.Functions.GetPlayerByCitizenId(citid)
        data.player = player
    else
        if not jobHistory then jobHistory = {} end
        if not jobs then jobs = {} end
        pD.job.name = newJob
        pD.job.label = Config.Jobs[newJob].label
        pD.job.onduty = Config.Jobs[newJob].defaultDuty
        pD.job.type = Config.Jobs[newJob].type
        jobGrade = Config.Jobs[newJob].grades[grade]
        pD.job.grade = {}
        pD.job.grade.name = jobGrade.name
        pD.job.grade.level = tostring(grade)
        pD.job.payment = jobGrade.payment
        jobs[job] = nil
        jobs[newJob] = pD.job
        if jobs["unemployed"] then jobs["unemployed"] = nil end
        pD.metadata = metaData
        pD.metadata.jobs = jobs
        pD.metadata.jobhistory[job] = jobHistory
        queryResult = MySQL.update.await('UPDATE players SET job = ?, metadata = ? WHERE citizenid = ?',{json.encode(pD.job),json.encode(pD.metadata),pD.citid}, function(result)
            if next(result) then
                cb(result)
            else
                cb(nil)
            end
        end)
        if queryResult then
            data.success[ercnt] = {
                ["subject"] = "User Data Saved",
                ["msg"] = string.format("JobHistory Update Success"),
                ["jsMsg"] = "User Saved!",
                ["color"] = "success",
                ["logName"] = "qbjobs",
                ["src"] = src,
                ["log"] = true
            }
            errorHandler(data.success)
        else
            data.error[ercnt] = {
                ["subject"] = "User Data Did Not Save",
                ["msg"] = string.format("JobHistory Update Failure, processJobHistory msg#004"),
                ["jsMsg"] = "Save Error!",
                ["color"] = "error",
                ["logName"] = "qbjobs",
                ["src"] = src,
                ["log"] = true,
                ["console"] = true
            }
            errorHandler(data.error)
            return data
        end
        data.player = QBCore.Player.GetOfflinePlayer(citid)
    end
    return data
end
--- prepares and saves metadata
local prepMetaData = function(meta)
    local src = meta.src
    local queryResult
    local data = {
        ["error"] = {},
        ["success"] = {}
    }
    local ercnt = 0
    if meta.isOnline then
        player.Functions.SetMetaData(meta.key, meta.data)
        QBCore.Player.Save(src)
    else
        if meta.citid and mgrBtnList.players[meta.citid] then mgrBtnList.players[meta.citid].PlayerData.metadata[meta.key] = meta.data end
        queryResult = MySQL.update.await('UPDATE players SET metadata = ? WHERE citizenid = ?',{json.encode(mgrBtnList.players[meta.citid].PlayerData.metadata),meta.citid}, function(result)
            if next(result) then
                cb(result)
            else
                cb(nil)
            end
        end)
        if queryResult then
            data.success[ercnt] = {
                ["subject"] = "JobHistory Update Success",
                ["msg"] = string.format('%s job history was successfully updated!', meta.citid),
                ["jsMsg"] = "JobHistory Update Success!",
                ["src"] = src,
                ["color"] = "success",
                ["logName"] = "qbjobs",
                ["log"] = true,
                ["notify"] = true
            }
            return errorHandler(data.success)
        else
            data.success[ercnt] = {
                ["subject"] = "JobHistory Update Failed",
                ["msg"] = string.format('%s job history was not updated!', meta.citid),
                ["jsMsg"] = "JobHistory Update Failed!",
                ["color"] = "error",
                ["logName"] = "qbjobs",
                ["src"] = src,
                ["log"] = true,
                ["console"] = true
            }
            return errorHandler(data.error)
        end
    end
end
--- Prepares keys for the vehPop table
local function countVehPop()
    for k in pairs(Config.Jobs) do
        vehCount[k] = 0
    end
end
--- Updates Duty Blips
local function updateBlips()
    local dutyPlayers = {}
    local publicPlayers = {}
    local players = QBCore.Functions.GetQBPlayers()
    for _,v in pairs(players) do
        if Config.Jobs[v.PlayerData.job.name].DutyBlips then
            local coords = GetEntityCoords(GetPlayerPed(v.PlayerData.source))
            local heading = GetEntityHeading(GetPlayerPed(v.PlayerData.source))
            if Config.Jobs[v.PlayerData.job.name].DutyBlips.type == "service" and v.PlayerData.job.onduty then
                dutyPlayers[#dutyPlayers+1] = {
                    ["source"] = v.PlayerData.source,
                    ["label"] = v.PlayerData.metadata["callsign"],
                    ["job"] = v.PlayerData.job.name,
                    ["location"] = {
                        ["x"] = coords.x,
                        ["y"] = coords.y,
                        ["z"] = coords.z,
                        ["w"] = heading
                    }
                }
            elseif Config.Jobs[v.PlayerData.job.name].DutyBlips.type == "public" then
                publicPlayers[#publicPlayers+1] = {
                    ["source"] = v.PlayerData.source,
                    ["label"] = v.PlayerData.metadata["callsign"],
                    ["job"] = v.PlayerData.job.name,
                    ["location"] = {
                        ["x"] = coords.x,
                        ["y"] = coords.y,
                        ["z"] = coords.z,
                        ["w"] = heading
                    }
                }
            end
        end
    end
    TriggerClientEvent("qb-jobs:client:updateBlips", -1, dutyPlayers, publicPlayers)
end
--- Sends Email to Phones
local function sendEmail(mail)
    local mailData = {}
    mailData.sender = mail.sender
    mailData.subject = mail.subject
    mailData.message = mail.message
    mailData.button = {}
    exports["qb-phone"]:sendNewMailToOffline(mail.recCitID, mailData)
end
--- Submits Job Applications
local function submitApplication(res)
    local src = res.src
    local player = QBCore.Functions.GetPlayer(src)
    local citid = player.PlayerData.citizenid
    local charInfo = player.PlayerData.charinfo
    local metaData = player.PlayerData.metadata
    local data = {
        ["error"] = {},
        ["success"] = {},
    }
    local ercnt = 0
    local jobData = {
        ["newJob"] = res.job:lower(),
        ["newGradeLevel"] = 0,
        ["newGradeLevelName"] = "No Grades",
        ["newJobHistory"] = nil
    }
    if metaData.jobhistory[jobData.newJob] then jobData.newJobHistory = metaData.jobhistory[jobData.newJob] end
    local jobInfo = Config.Jobs[res.job]
    local gender = Lang:t('email.mr')
    if charInfo.gender == 1 then
        gender = Lang:t('email.mrs')
    end
    local jhData = {
        ["src"] = res.src,
        ["citid"] = citid,
        ["job"] = jobData.newJob,
        [jobData.newJob] = {
            ["details"] = {},
            ["grades"] = {},
            ["status"] = "available",
            ["gradechange"] = 0,
            ["applycount"] = 0,
            ["hiredcount"] = 0,
        },
        ["player"] = player,
        ["index"] = {
            ["details"] = 1,
            ["grades"] = 1
        },
        ["jobHistory"] = player.PlayerData.metadata.jobhistory,
        ["isOnline"] = true
    }
    local msg, jobHistory
    if metaData.jobs[jobData.newJob] then
        data.error[ercnt] = {
            ["subject"] = "Already Employed",
            ["msg"] = string.format("%s %s is already employed in %s", charInfo.firstname, charInfo.firstname, jobData.newJob),
            ["jsMsg"] = "Already Employed!",
            ["src"] = src,
            ["color"] = "notice",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["notify"] = true
        }
        errorHandler(data.error)
        return false
    end
    if jobData.newJobHistory and jobData.newJobHistory.status == "pending" then
        data.error[ercnt] = {
            ["subject"] = "Application Pending",
            ["msg"] = string.format("%s %s is application pending in %s", charInfo.firstname, charInfo.lastname, jobData.newJob),
            ["jsMsg"] = "Application Pending!",
            ["src"] = src,
            ["color"] = "notice",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["notify"] = true
        }
        errorHandler(data.error)
        return false
    end
    if jobData.newJobHistory and not jobData.newJobHistory.rehireable then
        data.error[ercnt] = {
            ["subject"] = "Application Refused",
            ["msg"] = string.format("%s %s is blackListed in %s", charInfo.firstname, charInfo.firstname, jobData.newJob),
            ["jsMsg"] = "Application Refused!",
            ["src"] = src,
            ["color"] = "notice",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["notify"] = true
        }
        errorHandler(data.error)
        return false
    end
    if jobInfo then
        if res.grade then jobData.newGradeLevel = res.grade end
        if tonumber(jobData.newGradeLevel) ~= 0 then jobData.newGradeLevelName = jobInfo.grades[jobData.newGradeLevel].name end
        if jobInfo.jobBosses and not jobInfo.jobBosses[citid] then
            jhData[jhData.job].applycount += 1
            jhData[jhData.job].status = "pending"
            data.citid = citid
            data.sender = Lang:t('email.jobAppSender', {firstname = charInfo.firstname, lastname = charInfo.lastname})
            data.subject = Lang:t('email.jobAppSub', {lastname = charInfo.lastname, job = res.job})
            data.message = Lang:t('email.jobAppMsg', {gender = gender, lastname = charInfo.lastname, job = res.job, firstname = charInfo.firstname, phone = charInfo.phone})
            data.success[ercnt] = {
                ["subject"] = "Application Submitted",
                ["msg"] = Lang:t('info.new_job_app', {job = jobInfo.label}),
                ["jsMsg"] = "Application Submitted!",
                ["src"] = src,
                ["color"] = "notice",
                ["logName"] = "qbjobs",
                ["log"] = true,
                ["notify"] = true
            }
            errorHandler(data.success)
            for k in pairs(jobInfo.jobBosses) do
                CreateThread(function()
                    SetTimeout(math.random(1000, 2000), function()
                        data.recCitID = k
                        sendEmail(data)
                    end)
                end)
            end
        elseif not jobInfo.jobBosses or jobInfo.jobBosses[citid] then
            jobData.newGradeLevel = "1"
            jobData.newGradeLevelName = Config.Jobs[jobData.newJob].grades[jobData.newGradeLevel].name
            if jobInfo.jobBosses then
                local tmp = 1
                while Config.Jobs[jobData.newJob].grades[tmp] do
                    jobData.newGradeLevel = tmp
                    tmp += 1
                end
                jobData.newGradeLevelName = Config.Jobs[jobData.newJob].grades[jobData.newGradeLevel].name
            end
            jobData.newGradeLevel = tostring(jobData.newGradeLevel)
            jhData[jhData.job].status = "hired"
            jhData[jhData.job].hiredcount += 1
            jhData[jhData.job].grades[jhData.index.grades] = jobData.newGradeLevel
            jhData.index.grades += 1
            jhData[jhData.job].details[jhData.index.details] = string.format("Hired on as %s",jobData.newGradeLevelName)
            jhData.index.details += 1
            player.Functions.SetJob(jobData.newJob, jobData.newGradeLevel)
            player = QBCore.Functions.GetPlayer(src)
            player.Functions.AddToJobs(player.PlayerData.job.name, player.PlayerData.job)
            player = QBCore.Functions.GetPlayer(src)
            data.success[ercnt] = {
                ["subject"] = string.format("%s New Hire!",jobData.newJob),
                ["msg"] = string.format("Hired onto %s as %s",jobData.newJob, jobData.newGradeLevelName),
                ["jsMsg"] = string.format("Hired onto %s as %s",jobData.newJob, jobData.newGradeLevelName),
                ["src"] = src,
                ["color"] = "success",
                ["logName"] = "qbjobs",
                ["log"] = true,
                ["notify"] = true
            }
            errorHandler(data.success)
        else
            data.error[ercnt] = {
                ["subject"] = "Exploit Attempt: Boss Menu!",
                ["msg"] = string.format("%s attempted to exploit the Boss Menu through attempting of submitting insufficent data. submitApplication0001", player.PlayerData.license),
                ["jsMsg"] = "Exploit Failed!",
                ["color"] = "exploit",
                ["logName"] = "exploit",
                ["src"] = src,
                ["log"] = true,
                ["console"] = true
            }
            errorHandler(data.error)
            return false
        end
    end
    jobHistory = processJobHistory(jhData)
    if not jobHistory then return "failure" end
    player.Functions.AddToJobHistory(jhData.job,jobHistory)
    player = QBCore.Functions.GetPlayer(src)
    return "success"
end
exports("submitApplication",submitApplication)
--- multiJob Processing
local function processMultiJobs(res)
--[[
    ["newGradeLevelName"] = jobInfo.grades[jobData.newGradeLevel].name
    if res.quit then
        cjhData.status = "quit"
        cjhData.details[cjhData.index.details] = "Quit their job."
        cjhData.quitcount += 1
        cjhData.index.details += 1
        data.msg = "You quit From " .. jobData.currentJob
    else
        data.error[ercnt] = {
            ["subject"] = "Exploit Attempt: submitApplication",
            ["msg"] = string.format("%s attempted to exploit the fire feature", manager.PlayerData.license),
            ["color"] = "exploit",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["console"] = true
        }
    end
]]--
end
--- Send jobs to city hall
local function sendToCityHall()
    local isManaged, toCH
    for k,v in pairs(Config.Jobs) do
        isManaged = false
        if v.jobBosses then isManaged = true end
        if v.listInCityHall then
            toCH = {
                ["label"] = v.label,
                ["isManaged"] = isManaged
            }
            exports['qb-cityhall']:AddCityJob(k,toCH)
        end
    end
end
--- verifies society accounts SHOULD GO TO BANK
local function verifySociety()
    local bossList = {}
    local bossMenu = MySQL.query.await('SELECT `job_name` AS "jobName" FROM `management_funds` WHERE type = "boss"', {})
    for _,v in pairs(bossMenu) do bossList[v.jobName] = v.jobName end
    for k in pairs(Config.Jobs) do
        if not bossList[k] then
            MySQL.query.await("INSERT INTO `management_funds` (`job_name`,`amount`,`type`) VALUES (?,0,'boss')", {k})
        end
    end
end
--- sends MotorworksConfig table to qb-customs
local function sendToCustoms()
    local data = {}
    for k,v in pairs(Config.Jobs) do
        data[k] = v.MotorworksConfig
    end
    exports["qb-customs"]:buildLocations(data)
end
--- Generates list to pupulate the boss menu
local function buildManagementData(src)
    local player = QBCore.Functions.GetPlayer(src)
    local output = {
        ["error"] = {},
        ["success"] = {}
    }
    local ercnt = 0
    local playerJob = player.PlayerData.job
    local players = QBCore.Functions.GetQBPlayers()
    local jobCheck = {}
    local plist = {}
    local personal, jhList
    local sqlQuery = string.format("$.jobhistory.%s.status",playerJob.name)
    local queryResult = MySQL.query.await('SELECT citizenid AS citid, charinfo, metadata, license FROM `players` WHERE JSON_VALUE(metadata, ?) != "available"',{sqlQuery}, function(result)
        if next(result) then
            cb(result)
        else
            cb(nil)
        end
    end)
    mgrBtnList = nil
    mgrBtnList = {
        ["players"] = {},
        ["jobs"] = {}
    }
    for _,v in pairs(players) do
        plist[v.PlayerData.citizenid] = {
            ["PlayerData"] = {
                ["metadata"] = v.PlayerData.metadata,
                ["charinfo"] = v.PlayerData.charinfo,
                ["source"] = v.PlayerData.source,
                ["license"] = v.PlayerData.license
            }
        }
    end
    if queryResult then
        for _,v in pairs(queryResult) do
            mgrBtnList.players[v.citid] = {
                ["PlayerData"] = {}
            }
            if plist[v.citid] then
                v.metadata = plist[v.citid].PlayerData.metadata
                v.charinfo = plist[v.citid].PlayerData.charinfo
                v.source = plist[v.citid].PlayerData.source
                v.license = plist[v.citid].PlayerData.license
            else
                v.metadata = json.decode(v.metadata)
                v.charinfo = json.decode(v.charinfo)
            end
            jhList = v.metadata.jobhistory
            if Config.qbjobs.hideAvailableJobs then
                jhList = nil
                jhList = {}
                for k1,v1 in pairs(v.metadata.jobhistory) do
                    jhList[k1] = v1
                    if v1.status == "available" then jhList[k1] = nil end
                end
            end
            mgrBtnList.players[v.citid].PlayerData.metadata = v.metadata
            mgrBtnList.players[v.citid].PlayerData.charinfo = v.charinfo
            mgrBtnList.players[v.citid].PlayerData.license = v.license
            personal = {
                ["firstName"] = v.charinfo.firstname,
                ["lastName"] = v.charinfo.lastname,
                ["gender"] = "male",
                ["phone"] = v.charinfo.phone
            }
            if v.charinfo.gender > 0 then personal.gender = "female" end
            if v.metadata and v.metadata.jobhistory then
                for k1,v1 in pairs(v.metadata.jobhistory) do
                    if not jobCheck[k1] then
                        jobCheck[k1] = true
                        mgrBtnList.jobs[k1] = {
                            ["applicants"] = {},
                            ["employees"] = {},
                            ["pastEmployees"] = {},
                            ["deniedApplicants"] = {}
                        }
                    end
                    if v1.status == "pending" then
                        mgrBtnList.jobs[k1].applicants[v.citid] = {}
                        mgrBtnList.jobs[k1].applicants[v.citid].personal = personal
                        mgrBtnList.jobs[k1].applicants[v.citid].jobHistory = jhList
                        if v.metadata.rapsheet then mgrBtnList.jobs[k1].applicants[v.citid].rapSheet = v.metadata.rapsheet end
                    elseif v1.status == "hired" then
                        if k1 == playerJob.name and v.metadata.jobs and v.metadata.jobs[k1] then
                            personal.position = v.metadata.jobs[k1].grade
                            personal.payRate = v.metadata.jobs[k1].payment
                        end
                        mgrBtnList.jobs[k1].employees[v.citid] = {}
                        mgrBtnList.jobs[k1].employees[v.citid].personal = personal
                        mgrBtnList.jobs[k1].employees[v.citid].jobHistory = jhList
                        if v.metadata.rapsheet then mgrBtnList.jobs[k1].employees[v.citid].rapSheet = v.metadata.rapsheet end
                    elseif v1.status == "quit" or v1.status == "fired" or v1.status == "blacklisted" then
                        mgrBtnList.jobs[k1].pastEmployees[v.citid] = {}
                        mgrBtnList.jobs[k1].pastEmployees[v.citid].personal = personal
                        mgrBtnList.jobs[k1].pastEmployees[v.citid].jobHistory = jhList
                        if v.metadata.rapsheet then mgrBtnList.jobs[k1].pastEmployees[v.citid].rapSheet = v.metadata.rapsheet end
                    elseif v1.status == "denied" then
                        mgrBtnList.jobs[k1].deniedApplicants[v.citid] = {}
                        mgrBtnList.jobs[k1].deniedApplicants[v.citid].personal = personal
                        mgrBtnList.jobs[k1].deniedApplicants[v.citid].jobHistory = jhList
                        if v.metadata.rapsheet then mgrBtnList.jobs[k1].deniedApplicants[v.citid].rapSheet = v.metadata.rapsheet end
                    end
                end
            end
        end
    else
        output.error[ercnt] = {
            ["subject"] = "Management Data Not Found",
            ["msg"] = string.format("Management Data Select Failure, buildManagementData msg#001"),
            ["jsMsg"] = "Select Error!",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(data.error)
    end
    return mgrBtnList
end
--- Processes Jobs
local manageStaff = function(res)
    local src = res.manager.src
    local approveManagerAction = function(info)
        local citid = info.staff.citid
        local jobName = info.manager.job -- employer job (also employee job)
        local grade = "1"
        local gradeName = Config.Jobs[jobName].grades[grade].name
        local data = {
            ["citid"] = citid,
            ["job"] = jobName,
            ["prevJob"] = jobName,
            ["newJob"] = jobName,
            ["grade"] = grade,
            ["gradeName"] = gradeName,
            [jobName] = {
                ["hiredcount"] = 1,
                ["details"] = {string.format("was hired onto %s",jobName)},
                ["status"] = "hired"
            },
            ["error"] = {},
            ["success"] = {}
        }
        local output = setJob(data)
        if output.error and next(output.error) then return output end
    end
    local denyManagerAction = function(info)
        local ercnt = 0
        local data = {
            ["error"] = {},
            ["success"] = {}
        }
        local jobName = info.manager.job
        local citid = info.staff.citid
        data = {
            ["citid"] = citid,
            ["job"] = jobName,
            [jobName] = {
                ["denycount"] = 1,
                ["details"] = {string.format("was denied in %s",jobName)},
                ["status"] = "denied"
            },
            ["error"] = {},
            ["success"] = {}
        }
        local staff = setUnderlingStatus(res)
        local metaData = staff.player.PlayerData.metadata
        local jobHistory = processJobHistory(data)
        local output, queryResult
        staff = setUnderlingStatus(res)
        if staff.isOnline then output = staff.player.Functions.AddToJobHistory(jobName,jobHistory)
        else
            metaData.jobhistory[jobName] = jobHistory
            queryResult = MySQL.update.await('UPDATE players SET metadata = ? WHERE citizenid = ?',{json.encode(metaData),citid}, function(result)
                if next(result) then
                    cb(result)
                else
                    cb(nil)
                end
            end)
            if queryResult then
                data.success[ercnt] = {
                    ["subject"] = string.format("%s Denial", jobName),
                    ["msg"] = string.format("%s was denied with %s.", citid, jobName),
                    ["jsMsg"] = string.format("%s was denied with %s.", citid, jobName),
                    ["src"] = src,
                    ["color"] = "notice",
                    ["logName"] = "qbjobs",
                    ["log"] = true,
                    ["notify"] = true
                }
                errorHandler(data.success)
            else
                data.error[ercnt] = {
                    ["subject"] = "User Data Did Not Save",
                    ["msg"] = string.format("JobHistory Update Failure, processJobHistory msg#007"),
                    ["jsMsg"] = "Save Error!",
                    ["color"] = "error",
                    ["logName"] = "qbjobs",
                    ["src"] = src,
                    ["log"] = true,
                    ["console"] = true
                }
                errorHandler(data.error)
                return data
            end
            data.player = QBCore.Player.GetOfflinePlayer(citid)
        end
        if data.error and next(data.error) then return data end

        return data
    end
    local terminateManagerAction = function(info)
        local grade = "0"
        local jobName = "unemployed"
        local newJobName = jobName
        local prevJobName = info.manager.job
        local gradeName = Config.Jobs[jobName].grades[grade].name
        local data = {
            ["citid"] = info.staff.citid,
            ["grade"] = grade,
            ["gradeName"] = gradeName,
            ["job"] = prevJobName,
            ["prevJob"] = prevJobName,
            ["newJob"] = newJobName,
            [prevJobName] = {
                ["firedcount"] = 1,
                ["details"] = {string.format("was terminated from %s",prevJobName)},
                ["status"] = "fired"
            },
            ["error"] = {},
            ["success"] = {}
        }
        local output = setJob(data)
        if output.error and next(output.error) then return output end
    end
    local promoteManagerAction = function(info)
        local prevGrade = info.action.promote.grade
        local newGrade = tonumber(prevGrade) + 1
        local grade = tostring(newGrade)
        local data = {
            ["error"] = {},
            ["success"] = {}
        }
        local ercnt = 0
        local jobName = info.manager.job
        local newJobName = jobName
        local prevJobName = info.manager.job
        if not Config.Jobs[jobName].grades[grade] then
            data.error[ercnt] = {
                ["subject"] = "Can't Promote Any Higher",
                ["msg"] = string.format("%s can not be promoted any higher in %s.", info.staff.citid, jobName),
                ["jsMsg"] = "Highest grade reached!",
                ["src"] = src,
                ["color"] = "notice",
                ["logName"] = "qbjobs",
                ["log"] = true,
                ["notify"] = true
            }
            errorHandler(data.error)
            return data
        end
        local gradeName = Config.Jobs[jobName].grades[grade].name
        local prevGradeName = Config.Jobs[jobName].grades[prevGrade].name
        data = {
            ["citid"] = info.staff.citid,
            ["grade"] = grade,
            ["gradeName"] = gradeName,
            ["job"] = prevJobName,
            ["prevJob"] = prevJobName,
            ["newJob"] = newJobName,
            [prevJobName] = {
                ["gradechangecount"] = 1,
                ["details"] = {string.format("was promoted from %s to %s in %s",prevGradeName,gradeName,jobName)},
                ["status"] = "hired"
            },
            ["error"] = {},
            ["success"] = {}
        }
        local output = setJob(data)
        if output.error and next(output.error) then return output end
        data.success[ercnt] = {
            ["subject"] = "Promotion Alert",
            ["msg"] = string.format("%s was promoted from %s to %s in %s.", data.citid, prevGradeName, gradeName, jobName),
            ["jsMsg"] = string.format("%s was promoted from %s to %s in %s.", data.citid, prevGradeName, gradeName, jobName),
            ["src"] = src,
            ["color"] = "notice",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["notify"] = true
        }
        errorHandler(data.success)
    end
    local demoteManagerAction = function(info)
        local prevGrade = info.action.demote.grade
        local newGrade = tonumber(prevGrade) - 1
        local grade = tostring(newGrade)
        local ercnt = 0
        local data = {
            ["error"] = {},
            ["success"] = {}
        }
        local jobName = info.manager.job
        local newJobName = jobName
        local prevJobName = info.manager.job
        if not Config.Jobs[jobName].grades[grade] then
            data.error[ercnt] = {
                ["subject"] = "Can't Demote Any Lower",
                ["msg"] = string.format("%s can not be demote any lower in %s.", info.staff.citid, jobName),
                ["jsMsg"] = "Lowest grade reached!",
                ["src"] = src,
                ["color"] = "notice",
                ["logName"] = "qbjobs",
                ["log"] = true,
                ["notify"] = true
            }
            errorHandler(data.error)
            return data
        end
        local gradeName = Config.Jobs[jobName].grades[grade].name
        local prevGradeName = Config.Jobs[jobName].grades[prevGrade].name
        data = {
            ["citid"] = info.staff.citid,
            ["grade"] = grade,
            ["gradeName"] = gradeName,
            ["job"] = prevJobName,
            ["prevJob"] = prevJobName,
            ["newJob"] = newJobName,
            [prevJobName] = {
                ["gradechangecount"] = 1,
                ["details"] = {string.format("was demoted from %s to %s in %s",prevGradeName,gradeName,jobName)},
                ["status"] = "hired"
            },
            ["error"] = {},
            ["success"] = {}
        }
        local output = setJob(data)
        if output.error and next(output.error) then return output.error end
        data.success[ercnt] = {
            ["subject"] = "Demotion Alert",
            ["msg"] = string.format("%s was demoted from %s to %s in %s.", data.citid, prevGradeName, gradeName, jobName),
            ["jsMsg"] = string.format("%s was demoted from %s to %s in %s.", data.citid, prevGradeName, gradeName, jobName),
            ["src"] = src,
            ["color"] = "notice",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["notify"] = true
        }
        errorHandler(data.success)
    end
    local reconsiderManagerAction = function(info)
        local ercnt = 0
        local data = {
            ["error"] = {},
            ["success"] = {}
        }
        local jobName = info.manager.job
        local citid = info.staff.citid
        data = {
            ["citid"] = citid,
            ["job"] = jobName,
            [jobName] = {
                ["details"] = {string.format("was reconsidered in %s",jobName)},
                ["status"] = "pending"
            },
            ["error"] = {},
            ["success"] = {}
        }
        local staff = setUnderlingStatus(res)
        local metaData = staff.player.PlayerData.metadata
        local jobHistory = processJobHistory(data)
        local output, queryResult
        staff = setUnderlingStatus(res)
        if staff.isOnline then output = staff.player.Functions.AddToJobHistory(jobName,jobHistory)
        else
            metaData.jobhistory[jobName] = jobHistory
            queryResult = MySQL.update.await('UPDATE players SET metadata = ? WHERE citizenid = ?',{json.encode(metaData),citid}, function(result)
                if next(result) then
                    cb(result)
                else
                    cb(nil)
                end
            end)
            if queryResult then
                data.success[ercnt] = {
                    ["subject"] = string.format("%s Reconsidered", data.citid),
                    ["msg"] = string.format("%s was reconsidered with %s.", data.citid, jobName),
                    ["jsMsg"] = string.format("%s was reconsidered with %s.", data.citid, jobName),
                    ["src"] = src,
                    ["color"] = "notice",
                    ["logName"] = "qbjobs",
                    ["log"] = true,
                    ["notify"] = true
                }
                errorHandler(data.success)
            else
                data.error[ercnt] = {
                    ["subject"] = "User Data Did Not Save",
                    ["msg"] = string.format("JobHistory Update Failure, processJobHistory msg#006"),
                    ["jsMsg"] = "Save Error!",
                    ["color"] = "error",
                    ["logName"] = "qbjobs",
                    ["src"] = src,
                    ["log"] = true,
                    ["console"] = true
                }
                errorHandler(data.error)
                return data
            end
            data.player = QBCore.Player.GetOfflinePlayer(citid)
        end
        if data.error and next(data.error) then return data end

        return data
    end
    local payManagerAction = function(info)
        local ercnt = 0
        local data = {
            ["error"] = {},
            ["success"] = {}
        }
        local payRate = info.payRate
        local jobName = info.manager.job
        local citid = info.staff.citid
        data = {
            ["citid"] = citid,
            ["job"] = jobName,
            [jobName] = {
                ["details"] = {string.format("pay was changed to %s",payRate)},
                ["status"] = "hired"
            },
            ["error"] = {},
            ["success"] = {}
        }
        local staff = setUnderlingStatus(res)
        local metaData = staff.player.PlayerData.metadata
        local jobHistory = processJobHistory(data)
        local output, queryResult
        local jobData = metaData.jobs[jobName]
        jobData.payment = payRate
        staff = setUnderlingStatus(res)
        if staff.isOnline then
            output = staff.player.Functions.AddToJobHistory(jobName,jobHistory)
            if output.error and next(output.error) then return output end
            output = staff.player.Functions.AddtoJobs(jobName,jobData)
            if output.error and next(output.error) then return output end
            if staff.player.PlayerData.job.name == jobName then end
        else
            metaData.jobhistory[jobName] = jobHistory
            queryResult = MySQL.update.await('UPDATE players SET metadata = ? WHERE citizenid = ?',{json.encode(metaData),citid}, function(result)
                if next(result) then
                    cb(result)
                else
                    cb(nil)
                end
            end)
            if queryResult then
                data.success[ercnt] = {
                    ["subject"] = string.format("%s Reconsidered", data.citid),
                    ["msg"] = string.format("%s was reconsidered with %s.", data.citid, jobName),
                    ["jsMsg"] = string.format("%s was reconsidered with %s.", data.citid, jobName),
                    ["src"] = src,
                    ["color"] = "notice",
                    ["logName"] = "qbjobs",
                    ["log"] = true,
                    ["notify"] = true
                }
                errorHandler(data.success)
            else
                data.error[ercnt] = {
                    ["subject"] = "User Data Did Not Save",
                    ["msg"] = string.format("JobHistory Update Failure, processJobHistory msg#006"),
                    ["jsMsg"] = "Save Error!",
                    ["color"] = "error",
                    ["logName"] = "qbjobs",
                    ["src"] = src,
                    ["log"] = true,
                    ["console"] = true
                }
                errorHandler(data.error)
                return data
            end
            data.player = QBCore.Player.GetOfflinePlayer(citid)
        end
        if data.error and next(data.error) then return data end

        return data
    end
    res.citid = res.appcid
    local src = res.manager.src
    local manager = QBCore.Functions.GetPlayer(src)
    local managerJob = manager.PlayerData.job
    local staff = setUnderlingStatus(res)
    staff = staff.player.PlayerData
    local staffJob = {
        ["name"] = managerJob.name,
        ["type"] = managerJob.type,
        ["label"] = managerJob.label,
        ["grade"] = {
            ["level"] = 0,
            ["name"] = "Freelancer"
        },
        ["onduty"] = false,
        ["payment"] = 0,
        ["isboss"] = false
    }
    if staff.metadata.jobs[managerJob.name] then
        staffJob = nil
        staffJob = staff.metadata.jobs[managerJob.name]
    end
    local grade = staffJob.grade.level
    local data = {
        ["staff"] = {
            ["data"] = staff,
            ["citid"] = res.appcid,
            ["job"] = staffJob.name
        },
        ["manager"] = {
            ["data"] = manager,
            ["src"] = src,
            ["citid"] = manager.PlayerData.citizenid,
            ["job"] = managerJob.name,
        },
        ["action"] = {
            ["approve"] = {
                ["grade"] = "1",
                ["func"] = approveManagerAction
            },
            ["terminate"] = {
                ["status"] = "fired",
                ["grade"] = 0,
                ["job"] = "unemployed",
                ["func"] = terminateManagerAction
            },
            ["deny"] = {
                ["status"] = "denied",
                ["func"] = denyManagerAction
            },
            ["resign"] = {
                ["status"] = "quit",
                ["grade"] = 0,
                ["job"] = "unemployed"
            },
            ["promote"] = {
                ["status"] = "promote",
                ["grade"] = grade,
                ["func"] = promoteManagerAction
            },
            ["demote"] = {
                ["status"] = "demote",
                ["grade"] = grade,
                ["func"] = demoteManagerAction
            },
            ["reconsider"] = {
                ["status"] = "pending",
                ["func"] = reconsiderManagerAction
            },
            ["pay"] = {
                ["status"] = "pay",
                ["func"] = payManagerAction
            }
        },
        ["error"] = {},
        ["success"] = {}
    }
    local ercnt = 0
    local output
    if not buildManagementData(src) then
        data.error[ercnt] = {
            ["subject"] = "Jobs Boss Menu Error",
            ["msg"] = "Unable to Build Mgmt Data in function: manageStaff",
            ["jsMsg"] = "Failure!",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(data.error)
        return data
    end
    if not mgrBtnList.players[data.staff.citid] then
        data.error[ercnt] = {
            ["subject"] = "Player Does not Exist",
            ["msg"] = string.format("%s does not exist in %s", data.staff.citid, managerJob.name),
            ["jsMsg"] = "Exploit Failed",
            ["color"] = "exploit",
            ["logName"] = "exploit",
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(data.error)
        return data
    end
    output = data.action[res.action].func(data)
    return output
end
--- functions to run at resource start
local function kickOff()
    CreateThread(function()
        sendWebHooks()
        countVehPop()
        sendToCityHall()
        verifySociety()
        sendToCustoms()
        MySQL.query("DELETE FROM stashitems WHERE stash LIKE '%trash%'")
    end)
    CreateThread(function()
        while true do
            Wait(5000)
            updateBlips()
        end
    end)
end
-- Events
--- onResourceStart fiveM native
RegisterServerEvent('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        CreateThread(function()
            kickOff()
        end)
    end
end)
--- UpdateObject QBCore Event
RegisterServerEvent('QBCore:Server:UpdateObject', function()
	if source ~= '' then return false end
	QBCore = exports['qb-core']:GetCoreObject()
end)
--- Jobs Alert Event
RegisterServerEvent('qb-jobs:server:Alert', function(text)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local players = QBCore.Functions.GetQBPlayers()
    for _, v in pairs(players) do
        if v and v.PlayerData.job.type == 'leo' and v.PlayerData.job.onduty then
            local alertData = {title = Lang:t('info.new_call'), coords = {x = coords.x, y = coords.y, z = coords.z}, description = text}
            TriggerClientEvent("qb-phone:client:Alert", v.PlayerData.source, alertData)
            TriggerClientEvent('qb-jobs:client:Alert', v.PlayerData.source, coords, text)
        end
    end
end)
--- Event to call the populateJobs function from client
RegisterServerEvent('qb-jobs:server:populateJobs', function()
    local src = source
    populateJobs(src)
end)
--- Event to add items to vehicle
RegisterServerEvent('qb-jobs:server:addVehItems', function(data)
    local function SetCarItemsInfo(data)
        local items = {}
        local index = 1
        local player = QBCore.Functions.GetPlayer(source)
        if not player then return false end
        local playerJob = player.PlayerData.job
        if Config.Jobs[playerJob.name].Items[data.inv] then
            for _,v in pairs(Config.Jobs[playerJob.name].Items[data.inv]) do
                local vehType = false
                local authGrade = false
                for _,v1 in pairs(v.vehType) do
                    if v1 == Config.Jobs[playerJob.name].Vehicles[data.vehicle].type then
                        vehType = true
                    end
                end
                for _,v1 in pairs(v.authGrade) do
                    if v1 == playerJob.grade.level then
                        authGrade = true
                    end
                end
                if vehType and authGrade then
                    local itemInfo = QBCore.Shared.Items[v.name:lower()]
                    items[index] = {
                        name = itemInfo["name"],
                        amount = tonumber(v.amount),
                        info = v.info,
                        label = itemInfo["label"],
                        description = itemInfo["description"] and itemInfo["description"] or "",
                        weight = itemInfo["weight"],
                        type = itemInfo["type"],
                        unique = itemInfo["unique"],
                        useable = itemInfo["useable"],
                        image = itemInfo["image"],
                        slot = index,
                    }
                    index = index + 1
                end
            end
        end
        return items
    end
    data.inv = "trunk"
    local trunkItems = SetCarItemsInfo(data)
    data.inv = "glovebox"
    local gloveboxItems = SetCarItemsInfo(data)
    if trunkItems then
        exports['qb-inventory']:addTrunkItems(data.plate, trunkItems)
    end
    if gloveboxItems then
        exports['qb-inventory']:addGloveboxItems(data.plate, gloveboxItems)
    end
end)
--- Event to open the armory by eventually calling an export
RegisterServerEvent('qb-jobs:server:openArmory', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    local playerJob = player.PlayerData.job
    populateJobs(src) -- ensures client has latest QBCore.Shared.Jobs table.
    local index = 1
    local inv = {
        label = Config.Jobs[playerJob.name].Items.armoryLabel,
        slots = 30,
        items = {}
    }
    local items = Config.Jobs[playerJob.name].Items.items
    for key = 1, #items do
        for key2 = 1, #items[key].authorizedJobGrades do
            for key3 = 1, #items[key].locations do
                if items[key].locations[key3] == "armory" and items[key].authorizedJobGrades[key2] == playerJob.grade.level then
                    if items[key].type == "weapon" then items[key].info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4)) end
                    inv.items[index] = items[key]
                    inv.items[index].slot = index
                    index = index + 1
                end
            end
        end
    end
    exports['qb-inventory']:OpenInventory("shop", playerJob.name, inv, src)
end)
--- Event to open the stashes by calling an export
RegisterServerEvent("qb-jobs:server:openStash", function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    local playerJob = player.PlayerData.job
    exports['qb-inventory']:OpenInventory("stash", playerJob.name..Lang:t('headings.stash')..player.PlayerData.citizenid, false, source)
    TriggerClientEvent("inventory:client:SetCurrentStash", playerJob.name..Lang:t('headings.stash')..player.PlayerData.citizenid)
end)
--- Event to open the trash by calling an export
RegisterServerEvent('qb-jobs:server:openTrash', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local options = {
        maxweight = 4000000,
        slots = 300
    }
    exports['qb-inventory']:OpenInventory("stash", playerJob.name..Lang:t('headings.trash')..player.PlayerData.citizenid, options, source)
    TriggerClientEvent("inventory:client:SetCurrentStash", playerJob.name..Lang:t('headings.trash')..player.PlayerData.citizenid)
end)
--- Initializes job meta data for players (especially useful when new jobs are added)
RegisterServerEvent('qb-jobs:server:buildJobHistory', function()
    local jhp = {
        ["src"] = source,
        ["prePop"] = true,
    }
    buildJobHistory(jhp)
end)
--- Initilizes the Vehicle Tracker for the client.
RegisterServerEvent('qb-jobs:server:initilizeVehicleTracker', function()
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    vehTrack = {[player.PlayerData.citizenid] = {}}
end)
--- adds vehicles to job total
RegisterServerEvent('qb-jobs:server:addVehicle', function()
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    local playerJob = player.PlayerData.job
    vehCount[playerJob.name] += 1
end)
-- Deletes Vehicle from the server
RegisterServerEvent("qb-jobs:server:deleteVehicleProcess", function(result)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    local citid = player.PlayerData.citizenid
    if vehTrack[citid] and vehTrack[citid][result.plate] and vehTrack[citid][result.plate].selGar == "motorpool" and DoesEntityExist(NetworkGetEntityFromNetworkId(vehTrack[citid][result.plate].veh)) then
        if not result.noRefund and player.Functions.AddMoney("cash", Config.Jobs[playerJob.name].Vehicles[result.vehicle].depositPrice, playerJob.name .. Lang:t("success.depositFeesPaid", {value = Config.Jobs[playerJob.name].Vehicles[result.vehicle].depositPrice})) then
            TriggerClientEvent('QBCore:Notify', source, Lang:t("success.depositReturned", {value = Config.Jobs[playerJob.name].Vehicles[result.vehicle].depositPrice}), "success")
            TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Refund Deposit Success', 'green', string.format('%s received a refund of %s for returned vehicle!', GetPlayerName(source),Config.Jobs[playerJob.name].Vehicles[result.vehicle].depositPrice))
            exports['qb-management']:RemoveMoney(playerJob.name, Config.Jobs[playerJob.name].Vehicles[result.vehicle].depositPrice)
        end
    else
        TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Fake Refund Attempt', 'red', string.format('%s attempted to obtain a refund for returned vehicle!', GetPlayerName(source)))
    end
    vehCount[playerJob.name] -= 1
    vehTrack[citid][result.plate] = nil
end)
-- Callbacks
--- Verifies the vehicle count
QBCore.Functions.CreateCallback("qb-jobs:server:verifyMaxVehicles", function(source,cb)
    local test = true
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then cb(false) end
    local playerJob = player.PlayerData.job
    if Config.Jobs[playerJob.name].VehicleConfig.maxVehicles > 0 and Config.Jobs[playerJob.name].VehicleConfig.maxVehicles <= vehCount[playerJob.name] then
        QBCore.Functions.Notify(Lang:t("info.vehicleLimitReached"))
        test = false
    end
    cb(test)
end)
--- Processes Vehicles to be issued
QBCore.Functions.CreateCallback("qb-jobs:server:spawnVehicleProcessor", function(source,cb,result)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local vehicle = result.vehicle
    local selGar = result.selGar
    local total = 0
    local message = {}
    local jobStore
    result.source = source
    result.player = player
    if selGar == "ownGarage" then
        if Config.Jobs[playerJob.name].VehicleConfig.ownedParkingFee and Config.Jobs[playerJob.name].Vehicles[vehicle].parkingPrice then
            total += Config.Jobs[playerJob.name].Vehicles[vehicle].parkingPrice
            message.msg = Lang:t("success.parkingFeesPaid",{value = Config.Jobs[playerJob.name].Vehicles[vehicle].parkingPrice})
        end
    elseif selGar == "jobStore" then
        jobStore = exports['qb-vehicleshop']:BuyJobsVehicle(result)
        if not jobStore  then cb(false) end
    elseif selGar == "motorpool" then
        if Config.Jobs[playerJob.name].VehicleConfig.rentalFees and Config.Jobs[playerJob.name].Vehicles[vehicle].rentPrice then
            total += Config.Jobs[playerJob.name].Vehicles[vehicle].rentPrice
            message.rent = Lang:t("success.rentalFeesPaid",{value = Config.Jobs[playerJob.name].Vehicles[vehicle].rentPrice})
        end
        if Config.Jobs[playerJob.name].VehicleConfig.depositFees and Config.Jobs[playerJob.name].Vehicles[vehicle].depositPrice then
            total += Config.Jobs[playerJob.name].Vehicles[vehicle].depositPrice
            message.deposit = Lang:t("success.depositFeesPaid",{value = Config.Jobs[playerJob.name].Vehicles[vehicle].depositPrice})
        end
        if message.rent and message.deposit then message.msg = message.rent .. " " .. message.deposit
        elseif message.rent then message.msg = message.rent
        elseif message.deposit then message.msg = message.deposit end
    else
        TriggerClientEvent('QBCore:Notify', source, Lang.t("denied.invalidGarage"), "denied")
        TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Intrusion Attempted', 'red', string.format('%s attempted to obtain a vehicle!', GetPlayerName(source)))
        return false
    end
    if total > 0 then
        if not player.Functions.RemoveMoney("bank", total, message.msg) then
            if not player.Functions.RemoveMoney("cash", total, message.msg) then
                TriggerClientEvent('QBCore:Notify', source, Lang:t("error.not_enough", {value = total}), "error")
                return false
            end
        end
        exports['qb-management']:AddMoney(playerJob.name, total)
    end
    TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Money Received!', 'green', string.format('%s received money!', GetPlayerName(source)))
    if(not vehTrack[player.PlayerData.citizenid]) then vehTrack[player.PlayerData.citizenid] = {} end
    vehTrack[player.PlayerData.citizenid][result.plate] = {
        ["veh"] = result.veh,
        ["netid"] = result.netid,
        ["vehicle"] = vehicle,
        ["selGar"] = selGar
    }
    cb(true)
end)
--- Creates plates and ensures they are not in-use
QBCore.Functions.CreateCallback("qb-jobs:server:vehiclePlateCheck", function(source,cb,res)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local plate, vehProps, ppl
    local pplMax = 4
    res.platePrefix = Config.Jobs[playerJob.name].VehicleConfig.plate
    ppl = string.len(res.platePrefix)
    if ppl > pplMax then
        res.platePrefix = string.sub(res.platePrefix,1,pplMax)
        print("^1Your plate prefix is " .. ppl .. " must be less than ".. pplMax .. " chracters at: qb-jobs/jobs/" .. playerJob.name .. ".lua >>> VehicleConfig > Plate^7")
    end
    ppl = 7 - ppl
    res.min = 1 .. string.rep("0",ppl)
    res.max = 9 .. string.rep("9",ppl)
    res.vehTrack = vehTrack[player.PlayerData.citizenid]
    plate = exports["qb-vehicleshop"]:JobsPlateGen(res)
    if res.selGar == "ownGarage" then
        local result = MySQL.query.await('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
        if result[1] then vehProps = json.decode(result[1].mods) end
    end
    cb(plate, vehProps)
end)
--- Generates list to populate the vehicle selector menu
QBCore.Functions.CreateCallback('qb-jobs:server:sendGaragedVehicles', function(source,cb,data)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local vehShort, queryResult
    local vehList = {
        ["vehicles"] = {},
        ["vehiclesForSale"] = {},
        ["ownedVehicles"] = {},
    }
    local typeList = {}
    local index = {
        ["boat"] = 1,
        ["helicopter"] = 1,
        ["plane"] = 1,
        ["vehicle"] = 1
    }
    vehList.uiColors = Config.Jobs[playerJob.name].uiColors
    vehList.label = Config.Jobs[playerJob.name].label
    vehList.icons = Config.Jobs[playerJob.name].VehicleConfig.icons
    vehList.garage = data
    vehList.header = Config.Jobs[playerJob.name].label .. Lang:t('headings.garages')
    for _,v in pairs(Config.Jobs[playerJob.name].Locations.garages[data].spawnPoint) do
        typeList[v.type] = true
    end
    for k,v in pairs(Config.Jobs[playerJob.name].Vehicles) do
        if(v.authGrades[playerJob.grade.level] and typeList[v.type]) then
            vehList.vehicles[v.type] = {
                [index[v.type]] = {
                    ["spawn"] = k,
                    ["label"] = v.label,
                    ["icon"] = v.icon,
                }
            }
            if Config.Jobs[playerJob.name].VehicleConfig.depositFees then vehList.vehicles[v.type][index[v.type]].depositPrice = v.depositPrice  end
            if Config.Jobs[playerJob.name].VehicleConfig.rentalFees then vehList.vehicles[v.type][index[v.type]].rentPrice = v.rentPrice  end
            if v.purchasePrice and Config.Jobs[playerJob.name].VehicleConfig.allowPurchase then
                vehList.vehicles[v.type][index[v.type]].purchasePrice = v.purchasePrice
                vehList.vehiclesForSale[v.type] = {
                    [index[v.type]] = {
                        ["spawn"] = k,
                        ["label"] = v.label,
                        ["icon"] = v.icon,
                        ["purchasePrice"] = v.purchasePrice
                    }
                }
            end
            if v.parkingPrice and Config.Jobs[playerJob.name].VehicleConfig.allowPurchase and Config.Jobs[playerJob.name].VehicleConfig.ownedParkingFee then
                vehList.vehicles[v.type][index[v.type]].parkingPrice = v.parkingPrice
                vehList.vehiclesForSale[v.type][index[v.type]].parkingPrice = v.parkingPrice
            end
            index[v.type] += 1
        end
    end
    index.boat = 1
    index.helicopter = 1
    index.plane = 1
    index.vehicle = 1
    if Config.Jobs[playerJob.name].VehicleConfig.ownedVehicles then
        vehList.allowPurchase = true
    end
    queryResult = MySQL.query.await('SELECT plate, vehicle FROM player_vehicles WHERE citizenid = ? AND (state = ?) AND job = ?', {player.PlayerData.citizenid, 0, playerJob.name}, function(result)
        if next(result) then
            cb(result)
        else
            cb(nil)
        end
    end)
    for _, v in pairs(queryResult) do
        vehShort = Config.Jobs[playerJob.name].Vehicles[v.vehicle]
        if(vehShort.authGrades[playerJob.grade.level] and typeList[vehShort.type]) then
            if not vehList.ownedVehicles[vehShort.type] then vehList.ownedVehicles[vehShort.type] = {} end
            vehList.ownedVehicles[vehShort.type][index[vehShort.type]] = {
                ["plate"] = v.plate,
                ["spawn"] = v.vehicle,
                ["label"] = Config.Jobs[playerJob.name].Vehicles[v.vehicle].label,
                ["icon"] = Config.Jobs[playerJob.name].Vehicles[v.vehicle].icon
            }
            if(vehShort.parkingPrice) then vehList.ownedVehicles[vehShort.type][index[vehShort.type]].parkingPrice = vehShort.parkingPrice end
            index[vehShort.type] += 1
        end
    end
    cb(vehList)
end)
--- Sends Management Data to populate the boss menu
QBCore.Functions.CreateCallback('qb-jobs:server:sendManagementData', function(source,cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local playerJob = player.PlayerData.job
    buildManagementData(src)
    cb(mgrBtnList.jobs[playerJob.name])
end)
--- Processes management actions from the boss menu
QBCore.Functions.CreateCallback("qb-jobs:server:processManagementSubMenuActions", function(source,cb,res)
    local src = source
    local manager = QBCore.Functions.GetPlayer(src)
    local managerJob = manager.PlayerData.job
    local output = {["error"] = {}}
    res.manager = {
        ["src"] = src
    }
    output = manageStaff(res)
    if output and output.error and next(output.error) then
        return output
    end
    output = buildManagementData(src)
    if output and output.error and next(output.error) then
        return output
    end
    cb(mgrBtnList.jobs[managerJob.name])
end)
-- Commands
--- Creates the /duty command to go on and off duty
QBCore.Commands.Add("duty", Lang:t("commands.duty"), {}, false, function()
    TriggerClientEvent('qb-jobs:client:toggleDuty',-1)
end)
--- Creates the /jobs command to open the multi-jobs menu.
QBCore.Commands.Add("jobs", Lang:t("commands.duty"), {}, false, function()
    TriggerClientEvent('qb-jobs:client:multiJobsMenu',-1)
end)