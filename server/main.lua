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
--- places commas into numbers | credit https://lua-users.org/wiki/FormattingNumbers
local comma_value = function(amount)
    local k
    amount = tostring(amount)
    while true do
        amount, k = string.gsub(amount, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return Config.currencySymbol .. amount
end
--- Remove Decimal
local removeDecimal = function(amount)
    amount = string.format("%.0f",amount)
    return amount
end
--- Error / Message Handler
local errorHandler = function(error)
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
        if v.ban then exports["qb-core"]:BanPlayer(v.src) end
        if v.jsMsg then jsMsg[#jsMsg+1] = v.jsMsg end
    end
    return jsMsg
end
--- SQL handler
local sqlHandler = function(sql)
    local data = {
        ["success"] = {},
        ["error"] = {}
    }
    local ercnt = 0
    local queryResult = MySQL.query.await(sql.query, {}, function(result)
        if next(result) then
            cb(result)
        else
            cb(nil)
        end
    end)
    if not queryResult then
        data.error[ercnt] = {
            ["subject"] = "SQL Query Failed",
            ["msg"] = string.format("SQL Query Failed, from: ?",sql.from),
            ["jsMsg"] = "SQL Error!",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        return data
    end
    data.result = queryResult
    return data.result
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
--- Sends webhook from config to qb-smallresources
local sendWebHooks = function()
    for _,v in pairs(Config.Jobs) do
        if v.webHooks then
            exports['qb-smallresources']:addToWebhooks(v.webHooks)
        end
    end
end
--- Checks if underling is online
local function setUnderlingStatus(res)
    local src = res.src
    local citid = res.citid
    local output = {
        ["isOnline"] = true,
        ["player"] = {},
        ["error"] = {},
        ["success"] = {}
    }
    local ercnt = 0
    output.player = QBCore.Functions.GetPlayer(src)
    if not output.player or not next(output.player) then output.player = QBCore.Functions.GetPlayerByCitizenId(citid) end
    if not output.player or not next(output.player) then
        output.player = QBCore.Player.GetOfflinePlayer(citid)
        output.isOnline = false
    end
    if not output.player or not next(output.player) then
        output.error[ercnt] = {
            ["subject"] = "Player Does Not Exist!",
            ["msg"] = string.format("player does not exist in setUnderlingStatus! #msg001"),
            ["jsMsg"] = "Player Does Not Exist!",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        return output
    end
    return output
end
--- Prepares data for the buildJobHistory function for the current player
local function processJobHistory(jhData)
    local output = {
        ["error"] = {},
        ["success"] = {}
    }
    --- Builds the Job History metadata table.
    local function buildJobHistory(res)
        local jobName = res.job
        local ercnt = 0
        if not res[jobName] then res[jobName] = {} end
        if jobName == "unemployed" then
            output.error[ercnt] = "failed"
            return output
        end
        local jobData, status
        local jobHistory = {}
        if res.player.PlayerData.metadata.jobhistory then jobHistory = res.player.PlayerData.metadata.jobhistory end
        if jobHistory and jobHistory[jobName] and jobHistory[jobName].status then status = jobHistory[jobName].status end
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
            end
        end
        if jobHistory["unemployed"] then jobHistory["unemployed"] = nil end
        jobData = jobHistory[jobName]
        for kp,vp in pairs(jhList) do
            if type(vp) == "table"  then
                if res[jobName][kp] then
                    if jobData[kp] then
                        for _ in pairs(jobData[kp]) do
                            index[kp] += 1
                        end
                    end
                    if index[kp] == 0 then index[kp] = 1 end
                    for _,v in pairs(res[jobName][kp]) do
                        jobData[kp][index[kp]] = v
                        index[kp] += 1
                    end
                end
            elseif type(vp) == "number" then
                if not res[jobName][kp] then res[jobName][kp] = 0 end
                jobData[kp] += res[jobName][kp]
            elseif kp == "status" then
                if res[jobName][kp] then jobData[kp] = res[jobName][kp] end
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
        output.error[ercnt] = {
            ["subject"] = "Job Does Not Exist",
            ["msg"] = "Job Does Not Exist in processJobHistory, msg001",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        return output
    end
    jobHistory = buildJobHistory(jhData)
    return jobHistory
end
exports("processJobHistory",processJobHistory)
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
    local jobGrade, queryResult, sql
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
        sql = {
            ["query"] = string.format("UPDATE `players` SET `job` = '%s', `metadata` = '%s' WHERE `citizenid` = '%s'",json.encode(pD.job),json.encode(pD.metadata),pD.citid),
            ["from"] = "qb-jobs/server/main.lua > function > setJob"
        }
        queryResult = sqlHandler(sql)
        if queryResult.error and next(queryResult.error) then return queryResult end
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
        data.player = QBCore.Player.GetOfflinePlayer(citid)
    end
    return data
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
        return data
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
        return data
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
        return data
    end
    if jobInfo then
        if res.grade then jobData.newGradeLevel = res.grade end
        if tonumber(jobData.newGradeLevel) ~= 0 then jobData.newGradeLevelName = jobInfo.grades[jobData.newGradeLevel].name end
        if jobInfo.jobBosses and not jobInfo.jobBosses[citid] then
            jhData[jhData.job].applycount += 1
            jhData[jhData.job].status = "pending"
            jhData[jhData.job].details[jhData.index.details] = string.format("applied for %s", jobData.newJob)
            jhData.index.details += 1
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
            return data
        end
    end
    jobHistory = processJobHistory(jhData)
    if jobHistory and jobHistory.error then
        return jobHistory
    end
    player.Functions.AddToJobHistory(jhData.job,jobHistory)
    player = QBCore.Functions.GetPlayer(src)
    data.player = player
    return data
end
exports("submitApplication",submitApplication)
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
    local jobName = playerJob.name
    local players = QBCore.Functions.GetQBPlayers()
    local jobCheck = {}
    local plist = {}
    local societyAccounts = exports["qb-banking"]:sendSocietyAccounts(src,jobName)
    local personal, jhList, sql, queryResult
    sql = {
        ["query"] = string.format("SELECT `citizenid` AS 'citid', `charinfo`, `metadata`, `license` FROM `players` WHERE JSON_VALUE(`metadata`, '$.jobhistory.%s.status') != 'available'",playerJob.name),
        ["from"] = "qb-jobs/server/main.lua > function > buildManagementData"
    }
    queryResult = sqlHandler(sql)
    if queryResult.error and next(queryResult.error) then return queryResult end
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
            if Config.hideAvailableJobs then
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
                            ["deniedApplicants"] = {},
                            ["society"] = {
                                ["balance"] = comma_value(societyAccounts.accounts[k1])
                            },
                            ["config"] = {
                                ["currencySymbol"] = QBCore.Config.Money.CurrencySymbol
                            }
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
    local awrep = tonumber(1)
    if res.awrep then
        awrep = tonumber(res.awrep)
        if not QBCore.Functions.PrepForSQL(src,awrep,"^%d+$") then
            output.error[ercnt] = true
            return output
        end
        awrep += 1
    end
    local src = res.manager.src
    local citid = res.appcid
    local output = {
        ["error"] = {},
        ["success"] = {}
    }
    local ercnt = 0
    if not buildManagementData(src) then
        output.error[ercnt] = {
            ["subject"] = "Jobs Boss Menu Error",
            ["msg"] = "Unable to Build Mgmt Data in function: manageStaff",
            ["jsMsg"] = "Failure!",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        return output
    end
    if not mgrBtnList.players[citid] then
        output.error[ercnt] = {
            ["subject"] = "Player Does not Exist",
            ["msg"] = string.format("%s does not exist in %s", citid, managerJob.name),
            ["jsMsg"] = string.format("%s does not exist!", citid),
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        return output
    end
    local sql, queryResult
    local manager = QBCore.Functions.GetPlayer(src)
    local managerJob = manager.PlayerData.job
    local jobName = managerJob.name -- employer job (also employee job)
    local staff = setUnderlingStatus(res)
    local metaData = staff.player.PlayerData.metadata
    local staffJob = metaData.jobs[managerJob.name]
    if not staffJob then
        staffJob = {
            ["grade"] = {["level"] = 1}
        }
    end
    local data = {
        ["citid"] = citid,
        ["job"] = jobName,
        ["staff"] = {
            ["data"] = staff,
            ["citid"] = citid,
            ["job"] = staffJob.name
        },
        ["manager"] = {
            ["data"] = manager,
            ["src"] = src,
            ["citid"] = manager.PlayerData.citizenid,
            ["job"] = managerJob.name,
        }
    }
    local approveManagerAction = function(info)
        local grade = info.approve.grade
        local gradeName = Config.Jobs[jobName].grades[grade].name
        data.prevJob = jobName
        data.newJob = jobName
        data.grade = grade
        data.gradeName = gradeName
        data[jobName] = {
            ["hiredcount"] = 1,
            ["details"] = {string.format("was hired onto %s",jobName)},
            ["status"] = "hired"
        }
        output = setJob(data)
        if output.error and next(output.error) then return output end
        output.success[ercnt] = {
            ["subject"] = string.format("Approval Alert"),
            ["msg"] = string.format("%s was approved with %s.", citid, jobName),
            ["jsMsg"] = string.format("%s was approved.", citid),
            ["src"] = src,
            ["color"] = "notice",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["notify"] = true
        }
        errorHandler(output.success)
        return output
    end
    local denyManagerAction = function(_)
        data[jobName] = {
            ["denycount"] = 1,
            ["details"] = {string.format("was denied in %s",jobName)},
            ["status"] = "denied"
        }
        local jobHistory = processJobHistory(data)
        if staff.isOnline then
            output = staff.player.Functions.AddToJobHistory(jobName,jobHistory)
            return output
        end
        metaData.jobhistory[jobName] = jobHistory
        sql = {
            ["query"] = string.format("UPDATE `players` SET `metadata` = '%s' WHERE `citizenid` = '%s'",json.encode(metaData),citid),
            ["from"] = "qb-jobs/server/main.lua > function > manageStaff > denyManagerAction > "
        }
        queryResult = sqlHandler(sql)
        if queryResult.error and next(queryResult.error) then return queryResult end
        if output.error and next(output.error) then return output end
        output.success[ercnt] = {
            ["subject"] = string.format("Denial Alert"),
            ["msg"] = string.format("%s was denied with %s.", citid, jobName),
            ["jsMsg"] = string.format("%s was denied with %s.", citid, jobName),
            ["src"] = src,
            ["color"] = "notice",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["notify"] = true
        }
        errorHandler(output.success)
        return output
    end
    local terminateManagerAction = function(_)
        local grade = "0"
        jobName = "unemployed"
        local newJobName = jobName
        local prevJobName = data.manager.job
        local gradeName = Config.Jobs[jobName].grades[grade].name
        data.grade = grade
        data.gradeName = gradeName
        data.job = prevJobName
        data.prevJob = prevJobName
        data.newJob = newJobName
        data[prevJobName] = {
            ["firedcount"] = 1,
            ["details"] = {string.format("was terminated from %s",prevJobName)},
            ["status"] = "fired"
        }
        output = setJob(data)
        if output.error and next(output.error) then return output end
        output.success[ercnt] = {
            ["subject"] = string.format("Termination Alert"),
            ["msg"] = string.format("%s was Terminated from %s",citid,prevJobName),
            ["jsMsg"] = string.format("Terminated from %s",prevJobName),
            ["src"] = src,
            ["color"] = "notice",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["notify"] = true
        }
        errorHandler(output.success)
        return output
    end
    local gradeManagerAction = function(info)
        local prevGrade = info[res.action].prevGrade
        local newGrade = info[res.action].newGrade
        local grade = tostring(newGrade)
        if not Config.Jobs[jobName].grades[grade] then
            output.error[ercnt] = {
                ["subject"] = string.format("Can't %s Any Further",res.action),
                ["msg"] = string.format("%s can not be info[res.action].details any further in %s.", citid, jobName),
                ["jsMsg"] = "Highest grade reached!",
                ["src"] = src,
                ["color"] = "notice",
                ["logName"] = "qbjobs",
                ["log"] = true,
                ["notify"] = true
            }
            errorHandler(output.error)
            return output
        end
        local gradeName = Config.Jobs[jobName].grades[grade].name
        local prevGradeName = Config.Jobs[jobName].grades[prevGrade].name
        data.grade = grade
        data.gradeName = gradeName
        data.prevJob = jobName
        data.newJob = jobName
        data[jobName] = {
            ["gradechangecount"] = 1,
            ["details"] = {string.format("was %s from %s to %s",info[res.action].details,prevGradeName,gradeName)}
        }
        output = setJob(data)
        if output.error and next(output.error) then return output end
        output.success[ercnt] = {
            ["subject"] = string.format("%s Alert",info[res.action].subject),
            ["msg"] = string.format("%s in %s.",info[res.action].details, jobName),
            ["jsMsg"] = info[res.action].subject,
            ["src"] = src,
            ["color"] = "notice",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["notify"] = true
        }
        errorHandler(output.success)
        return output
    end
    local reconsiderManagerAction = function(info)
        data[jobName] = {
            ["details"] = {string.format("was reconsidered in %s",jobName)},
            ["status"] = info.reconsider.status
        }
        local jobHistory = processJobHistory(data)
        staff = setUnderlingStatus(res)
        if staff.isOnline then output = staff.player.Functions.AddToJobHistory(jobName,jobHistory)
        else
            metaData.jobhistory[jobName] = jobHistory
            sql = {
                ["query"] = string.format("UPDATE `players` SET `metadata` = '%s' WHERE `citizenid` = '%s'",json.encode(metaData),citid),
                ["from"] = "qb-jobs/server/main.lua > function > > manageStaff > reconsiderManagerAction"
            }
            queryResult = sqlHandler(sql)
            if queryResult.error and next(queryResult.error) then return queryResult end
            output.success[ercnt] = {
                ["subject"] = string.format("Reconsideration Alert"),
                ["msg"] = string.format("%s was reconsidered with %s.", citid, jobName),
                ["jsMsg"] = string.format("%s was reconsidered with %s.", citid, jobName),
                ["src"] = src,
                ["color"] = "notice",
                ["logName"] = "qbjobs",
                ["log"] = true,
                ["notify"] = true
            }
            errorHandler(output.success)
        end
        if output.error and next(output.error) then return output end
        return output
    end
    local payManagerAction = function(_)
        local payRate = res.payRate
        if not QBCore.Functions.PrepForSQL(src,payRate,"^%d+$") then
            output.error[ercnt] = true
            return output
        end
        local jobHistory = processJobHistory(data)
        local jobData = metaData.jobs[jobName]
        jobData.payment = payRate
        if staff.isOnline then
            output = staff.player.Functions.AddToJobHistory(jobName,jobHistory)
            if output.error and next(output.error) then return output end
            output = staff.player.Functions.AddToJobs(jobName,jobData)
            if output.error and next(output.error) then return output end
            if staffJob.name == jobName then staff.player.Functions.UpdateJob(jobData) end
            if output.error and next(output.error) then return output end
            output = setUnderlingStatus(res)
            return output
        else
            metaData.jobhistory[jobName] = jobHistory
            metaData.jobs[jobName] = jobData
            if staffJob.name == jobName then
                staffJob = nil
                staffJob = jobData
            end
            sql = {
                ["query"] = string.format("UPDATE `players` SET `job` = '%s', `metadata` = '%s' WHERE `citizenid` = '%s'",json.encode(staffJob),json.encode(metaData),citid),
                ["from"] = "qb-jobs/server/main.lua > function > manageStaff > payMangerAction"
            }
            queryResult = sqlHandler(sql)
            if queryResult.error and next(queryResult.error) then return queryResult end
            data.player = QBCore.Player.GetOfflinePlayer(citid)
        end
        if data.error and next(data.error) then return data end
        data.success[ercnt] = {
            ["subject"] = string.format("Pay Adjustment Alert"),
            ["msg"] = string.format("%s pay was adjusted to %s in %s.", data.citid, payRate, jobName),
            ["jsMsg"] = string.format("%s pay was adjusted to %s in %s.", data.citid, payRate, jobName),
            ["src"] = src,
            ["color"] = "notice",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["notify"] = true
        }
        errorHandler(data.success)
        return data
    end
    local awrepManagerAction = function(info)
        data[jobName] = {
            ["details"] = {string.format('%s was %s: %s in %s',citid,info[res.action].details,info[res.action].awrep,jobName)},
            [info[res.action].confs] = {info[res.action].awrep},
            ["status"] = "hired"
        }
        local jobHistory = processJobHistory(data)
        if staff.isOnline then
            output = staff.player.Functions.AddToJobHistory(jobName,jobHistory)
            if output.error and next(output.error) then return output end
            output = setUnderlingStatus(res)
            return output
        else
            metaData.jobhistory[jobName] = jobHistory
            sql = {
                ["query"] = string.format("UPDATE `players` SET `metadata` = '%s' WHERE `citizenid` = '%s'",json.encode(metaData),citid),
                ["from"] = "qb-jobs/server/main.lua > function > manageStaff > awrepManagerAction"
            }
            queryResult = sqlHandler(sql)
            if queryResult.error and next(queryResult.error) then return queryResult end
            data.player = QBCore.Player.GetOfflinePlayer(citid)
        end
        if data.error and next(data.error) then return data end
        data.success[ercnt] = {
            ["subject"] = string.format("%s Alert",info[res.action].subject),
            ["msg"] = string.format('%s was %s: "%s" in %s',citid,info[res.action].details,info[res.action].awrep,jobName),
            ["jsMsg"] = string.format('was %s: "%s"',info[res.action].details,info[res.action].awrep),
            ["src"] = src,
            ["color"] = "notice",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["notify"] = true
        }
        errorHandler(data.success)
        return data
    end
    data.action = {
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
            ["prevGrade"] = staffJob.grade.level,
            ["newGrade"] = tonumber(staffJob.grade.level) + 1,
            ["grade"] = tonumber(staffJob.grade.level) + 1,
            ["details"] = "promoted",
            ["subject"] = "Promotion",
            ["func"] = gradeManagerAction
        },
        ["demote"] = {
            ["status"] = "demote",
            ["prevGrade"] = staffJob.grade.level,
            ["newGrade"] = tonumber(staffJob.grade.level) - 1,
            ["details"] = "demoted",
            ["subject"] = "Demotion",
            ["func"] = gradeManagerAction
        },
        ["reconsider"] = {
            ["status"] = "pending",
            ["func"] = reconsiderManagerAction
        },
        ["pay"] = {
            ["status"] = "pay",
            ["func"] = payManagerAction
        },
        ["award"] = {
            ["awrep"] = Config.Jobs[jobName].management.awards[awrep].title,
            ["details"] = "awarded",
            ["subject"] = "Award",
            ["confs"] = "awards",
            ["func"] = awrepManagerAction
        },
        ["reprimand"] = {
            ["awrep"] = Config.Jobs[jobName].management.reprimands[awrep].title,
            ["details"] = "reprimanded",
            ["subject"] = "Reprimand",
            ["confs"] = "reprimands",
            ["func"] = awrepManagerAction
        },
    }
    output = data.action[res.action].func(data.action)
    return output
end
--- functions to run at resource start
local function kickOff()
    CreateThread(function()
        sendWebHooks()
        countVehPop()
        sendToCityHall()
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
    local plate, vehProps, ppl, sql, queryResult
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
        sql = {
            ["query"] = string.format("SELECT `mods` FROM `player_vehicles` WHERE `plate` = '%s'",plate),
            ["from"] = "qb-jobs/server/main.lua > callback > vehiclePlateCheck"
        }
        queryResult = sqlHandler(sql)
        if queryResult.error and next(queryResult.error) then return queryResult end
        if queryResult[1] then vehProps = json.decode(queryResult[1].mods) end
    end
    cb(plate, vehProps)
end)
--- Generates list to populate the vehicle selector menu
QBCore.Functions.CreateCallback('qb-jobs:server:sendGaragedVehicles', function(source,cb,data)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local vehShort, queryResult, sql
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
    vehList.icons = Config.Jobs[playerJob.name].menu.icons
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
    sql = {
        ["query"] = string.format("SELECT `plate`, `vehicle` FROM `player_vehicles` WHERE `citizenid` = '%s' AND (`state` = '%s') AND `job` = '%s'",player.PlayerData.citizenid, 0, playerJob.name),
        ["from"] = "qb-jobs/server/main.lua > callback > sendGaragedVehicles"
    }
    queryResult = sqlHandler(sql)
    if queryResult.error and next(queryResult.error) then return queryResult end
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
    local managerLicense = manager.PlayerData.license
    local ercnt = 0
    local output = {
        ["error"] = {}
    }
    res.manager = {
        ["src"] = src
    }
    if not mgrBtnList.players[res.appcid] then
        output.error[ercnt] = {
            ["subject"] = "Player Data Missing",
            ["msg"] = string.format("Player data missing; Boss Menu used by: ?",res.appcid),
            ["jsMsg"] = "Player Data Missing",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        cb(output)
        return output
    end
    res.citid = res.appcid
    if not QBCore.Functions.PrepForSQL(src,res.action,"^%a+$") then
        output.error[ercnt] = {
            ["subject"] = "Action Data Invalid",
            ["msg"] = string.format("Action data Invalid Boss Menu used by: ?",managerLicense),
            ["jsMsg"] = "Action Data Invalid",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        cb(output)
        return output
    end
    output = manageStaff(res)
    if not output or output.error and next(output.error) then
        cb(output)
        return output
    end
    output = buildManagementData(src)
    if not output or output.error and next(output.error) then
        cb(output)
        return output
    end
    cb(mgrBtnList.jobs[managerJob.name])
    return output
end)
--- Processes society actions from the boss menu
QBCore.Functions.CreateCallback("qb-jobs:server:processManagementSocietyActions", function(source,cb,res)
    local src = source
    local manager = QBCore.Functions.GetPlayer(src)
    local managerJob = manager.PlayerData.job
    local managerLicense = manager.PlayerData.license
    local ercnt = 0
    local output = {
        ["error"] = {}
    }
    if not QBCore.Functions.PrepForSQL(src,res.depwit,"^%d+$") then
        output.error[ercnt] = {
            ["subject"] = "Amount is Invalid",
            ["msg"] = string.format("Amount is invalid boss menu used by: %s",managerLicense),
            ["jsMsg"] = "Amount is Invalid",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        cb(output)
        return output
    end
    output = exports["qb-banking"]:societyDepwit(src,res.depwit,res.selector)
    output = buildManagementData(src)
    if not output or output.error and next(output.error) then
        cb(output)
        return output
    end
    cb(mgrBtnList.jobs[managerJob.name])
    return output
end)
--- Processes multiJob menu items
QBCore.Functions.CreateCallback("qb-jobs:server:processMultiJob", function(source,cb,res)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local playerJob = player.PlayerData.job
    local playerJobs = player.PlayerData.metadata.jobs
    local job = playerJobs[res.job]
    local jobCheck = function(data)
        if not playerJobs[data.job] then
            output.error[ercnt] = {
                ["subject"] = "Does Not Work Here!",
                ["msg"] = string.format("player does not exist in processMultiJob Callback! #msg001"),
                ["jsMsg"] = "Player Does Not Exist!",
                ["color"] = "error",
                ["logName"] = "qbjobs",
                ["src"] = src,
                ["log"] = true,
                ["console"] = true
            }
            errorHandler(output.error)
            cb(output)
            return false
        end
        return true
    end
    local function activate(data)
        if not jobCheck(data) then return false end
        local output = {
            ["error"] = {},
            ["success"] = {}
        }
        local ercnt = 0
        player.Functions.SetActiveJob(job)
        return output
    end
    local function quit(data)
        if not jobCheck(data) then return false end
        local output = {
            ["src"] = src,
            ["citid"] = data.citid,
            ["job"] = data.job,
            [data.job] = {
                ["status"] = "quit",
                ["details"] = {[1] = "Resigned"},
                ["quitcount"] = 1
            },
            ["error"] = {},
            ["success"] = {}
        }
        local ercnt = 0
        local jobHistory = processJobHistory(output)
        player.Functions.AddToJobHistory(data.job,jobHistory)
        if data.job == playerJob.name then player.Functions.SetJob("unemployed", "0") end
        player.Functions.RemoveFromJobs(res.job)
        output.success[ercnt] = {
            ["subject"] = "User Resigned",
            ["msg"] = string.format("%s resigned from %s",player.PlayerData.citizenid,playerJob.name),
            ["jsMsg"] = "User Resigned!",
            ["color"] = "success",
            ["logName"] = Config.Jobs[playerJob.name].webHooks[playerJob.name],
            ["src"] = src,
            ["log"] = true,
            ["notify"] = true
        }
        player.Functions.SetActiveJob(job)
        return output
    end
    local function apply(data)
        local output = {
            ["src"] = data.src,
            ["citid"] = data.citid,
            ["job"] = data.job,
            ["grade"] = 0,
            ["error"] = {},
            ["success"] = {}
        }
        output = submitApplication(output)
        return output
    end
    local output = {
        ["error"] = {},
        ["success"] = {}
    }
    local ercnt = 0
    local action = {
        ["activate"] = {["func"] = activate},
        ["quit"] = {["func"] = quit},
        ["apply"] = {["func"] = apply},
    }
    if not QBCore.Functions.PrepForSQL(src,res.action,"^%a+$") then
        output.error[ercnt] = {
            ["subject"] = "Action is Invalid",
            ["msg"] = string.format("Action is invalid multi-job menu used by: %s",player.PlayerData.license),
            ["jsMsg"] = "Action is Invalid",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        cb(output)
        return output
    end
    if not QBCore.Functions.PrepForSQL(src,res.job,"^%a+$") then
            output.error[ercnt] = {
                ["subject"] = "Job is Invalid",
                ["msg"] = string.format("Job is invalid multiJob menu used by: %s",player.PlayerData.license),
                ["jsMsg"] = "Job is Invalid",
                ["color"] = "error",
                ["logName"] = "qbjobs",
                ["src"] = src,
                ["log"] = true,
                ["console"] = true
            }
            cb(output)
            return output
    end
    output.job = res.job
    output.src = src
    output.citid = player.PlayerData.citizenid
    output = action[res.action].func(output)
    cb(output)
    QBCore = exports['qb-core']:GetCoreObject()
    kickOff()
    return output
end)
-- Commands
--- Creates the /duty command to go on and off duty
QBCore.Commands.Add("duty", Lang:t("commands.duty"), {}, false, function()
    local src = source
    TriggerClientEvent('qb-jobs:client:toggleDuty',src)
end)
--- Creates the /jobs command to open the multi-jobs menu.
QBCore.Commands.Add("jobs", Lang:t("commands.duty"), {}, false, function()
    TriggerClientEvent('qb-jobs:client:multiJobMenu',-1)
end)