-- Variables
--- populates QBCore table
local QBCore = exports['qb-core']:GetCoreObject()
--- NUI Vehicle Button List Table
local vehBtnList = {}
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
exports['qb-core']:AddGangs(Config.Gangs)
-- Functions
--- places commas into numbers | credit https://lua-users.org/wiki/FormattingNumbers
local comma_value = function(amount)
    local k
    amount = tostring(amount)
    while true do
        amount, k = string.gsub(amount, "^(-?%d+)(%d%d%d)", '%1, %2')
        if (k==0) then
            break
        end
    end
    return string.format("%s%s", Config.currencySymbol, amount)
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
    local output = {
        ["success"] = {},
        ["error"] = {}
    }
    local queryResult = MySQL.query.await(sql.query,{},function(result)
        if next(result) then
            cb(result)
        else
            cb(nil)
        end
    end)
    if not queryResult then
        output.error[0] = {
            ["subject"] = "SQL Query Failed",
            ["msg"] = string.format("SQL Query Failed, from: ?", sql.from),
            ["jsMsg"] = "SQL Error!",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        return output
    end
    output.result = queryResult
    return output.result
end
--- switches between job or gang
local selectJobGang = function(jgType, playerJob, playerGang)
    local output = {
        ["Jobs"] = {
            ["conf"] = Config[jgType][playerJob.name],
            ["jg"] = playerJob,
            ["pd"] = {
                ["type"] = "job",
                ["types"] = "jobs",
                ["history"] = "jobhistory",
                ["current"] = "currentJob",
                ["currentName"] = "currentJobName",
                ["label"] = "employees",
                ["pastLabel"] = "pastEmployees",
                ["prev"] = "prevJob",
                ["set"] = "SetJob",
                ["add"] = "AddToJobs",
                ["addHistory"] = "AddToJobHistory",
                ["remove"] = "RemoveFromJobs",
                ["civilian"] = "unemployed",
                ["active"] = "SetActiveJob"
            }
        },
        ["Gangs"] = {
            ["conf"] = Config[jgType][playerGang.name],
            ["jg"] = playerGang,
            ["pd"] =  {
                ["type"] = "gang",
                ["types"] = "gangs",
                ["history"] = "ganghistory",
                ["current"] = "currentGang",
                ["currentName"] = "currentGangName",
                ["label"] = "members",
                ["pastLabel"] = "pastMembers",
                ["prev"] = "prevGang",
                ["set"] = "SetGang",
                ["add"] = "AddToGangs",
                ["addHistory"] = "AddToGangHistory",
                ["remove"] = "RemoveFromGangs",
                ["civilian"] = "none",
                ["active"] = "SetActiveGang"
            }
        }
    }
    return output[jgType]
end
exports("selectJobGang", selectJobGang)
--- Populates the server side QBCore.Shared.Jobs table
local populateJobsNGangs = function(src)
    CreateThread(function()
        exports['qb-core']:AddJobs(Config.Jobs)
        for k, v in pairs(Config.Jobs) do
            TriggerClientEvent('QBCore:Client:OnSharedUpdate', src, "Jobs", k,v)
        end
    end)
    CreateThread(function()
        exports['qb-core']:AddGangs(Config.Gangs)
        for k, v in pairs(Config.Gangs) do
            TriggerClientEvent('QBCore:Client:OnSharedUpdate', src, "Gangs", k,v)
        end
    end)
end
exports('populateJobsNGangs', populateJobsNGangs)
--- Sends webhook from config to qb-smallresources
local sendWebHooks = function()
    for _,v in pairs(Config.Jobs) do
        if v.webHooks then
            exports['qb-smallresources']:addToWebhooks(v.webHooks)
        end
    end
end
--- Checks if underling is online
local setUnderlingStatus = function(res)
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
local processHistory = function(hData, jgType)
    local output = {
        ["error"] = {},
        ["success"] = {}
    }
    --- Builds the Job History metadata table.
    local buildHistory = function(res)
        local pd = res.pd
        pd.name = res[pd.type]
        if not res[pd.name] then res[pd.name] = {} end
        if pd.name == "unemployed" or pd.name == "none" then
            output.error[0] = "failed"
            return output
        end
        local jgData, status
        local history = {}
        if res.player.PlayerData.metadata[pd.history] then history = res.player.PlayerData.metadata[pd.history] end
        if history and history[pd.name] and history[pd.name].status then status = history[pd.name].status end
        local hList = {
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
        for k in pairs(Config[jgType]) do
            if not history[k] then
                history[k] = hList
            end
        end
        if history["none"] then history["none"] = nil end
        if history["unemployed"] then history["unemployed"] = nil end
        jgData = history[pd.name]
        for kp, vp in pairs(hList) do
            if type(vp) == "table"  then
                if res[pd.name][kp] then
                    if jgData[kp] then
                        for _ in pairs(jgData[kp]) do
                            index[kp] += 1
                        end
                    end
                    if index[kp] == 0 then index[kp] = 1 end
                    for _,v in pairs(res[pd.name][kp]) do
                        jgData[kp][index[kp]] = v
                        index[kp] += 1
                    end
                end
            elseif type(vp) == "number" then
                if not res[pd.name][kp] then res[pd.name][kp] = 0 end
                jgData[kp] += res[pd.name][kp]
            elseif kp == "status" then
                if res[pd.name][kp] then jgData[kp] = res[pd.name][kp] end
            end
        end
        if pd.name == "none" then jgData = nil end
        if pd.name == "unemployed" then jgData = nil end
        return jgData
    end
    local data, history
    if not hData.player then
        data = setUnderlingStatus(hData)
        hData.isOnline = data.isOnline
        hData.player = data.player
    end
    if not hData.player then return data end
    local playerJob = hData.player.PlayerData.job
    local playerGang = hData.player.PlayerData.gang
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    local conf = cdata.conf
    local pd = cdata.pd
    hData.pd = pd
    hData.error = {}
    hData.success = {}
    if not Config[jgType][hData[pd.type]] then
        output.error[0] = {
            ["subject"] = "Job Does Not Exist",
            ["msg"] = "Job Does Not Exist in processHistory, msg001",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        return output
    end
    history = buildHistory(hData)
    return history
end
exports("processHistory", processHistory)
--- Sets the job or gang up for the underling
local setJobGang = function(res, jgType)
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
    local jobHistory = processHistory(data, jgType)
    if not Config.Jobs[res.job] then
        data.error[ercnt] = {
            ["subject"] = "Job does not exist!",
            ["msg"] = string.format("%s attempted to set a job that didn't exist in processHistory msg#003", player.PlayerData.license),
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
        player.Functions[pd.set](newJob, grade)
        player = QBCore.Functions.GetPlayerByCitizenId(citid)
        player.Functions[pd.addHistory](prevJob, jobHistory)
        player.Functions[pd.add](prevJob, nil)
        player.Functions[pd.add](player.PlayerData.job.name, player.PlayerData.job)
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
            ["query"] = string.format("UPDATE `players` SET `job` = '%s',`metadata` = '%s' WHERE `citizenid` = '%s'", json.encode(pD.job),json.encode(pD.metadata),pD.citid),
            ["from"] = "qb-jobs/server/main.lua > function > setJob"
        }
        queryResult = sqlHandler(sql)
        if queryResult.error and next(queryResult.error) then return queryResult end
        data.success[ercnt] = {
            ["subject"] = "User Data Saved",
            ["msg"] = string.format("JobHistory Update Success"),
            ["jsMsg"] = "User Saved!",
            ["color"] = "sucecess",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true
        }
        errorHandler(data.success)
        data.player = QBCore.Player.GetOfflinePlayer(citid)
    end
    return data
end
--- Checks for Duplicate Jobs / Gangs
local checkUniqueJobGang = function()
    local output = {
        ["counter"] = {},
        ["success"] = {},
        ["error"] = {}
    }
    local countPop = function(conf)
        for k in pairs(conf) do
            if output.counter[k] then
                output.error[0] = {
                    ["subject"] = "Duplicate Job & Gang",
                    ["msg"] = string.format("%s is a dupe! Job & gang names must be unique.", k),
                    ["color"] = "error",
                    ["logName"] = "qbjobs",
                    ["src"] = src,
                    ["log"] = true,
                    ["console"] = true
                }
                errorHandler(output.error)
            end
            output.counter[k] = 0
        end
        return output
    end
    countPop(Config.Jobs)
    countPop(Config.Gangs)
    return output
end
--- Prepares keys for the vehPop table
local countVehPop = function()
    local countPop = function(conf)
        local output = {
            ["success"] = {},
            ["error"] = {}
        }
        for k in pairs(conf) do
            if not vehCount[k] then
            end
            vehCount[k] = 0
        end
    end
    countPop(Config.Jobs)
    countPop(Config.Gangs)
end
--- Updates Duty Blips
local updateBlips = function()
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
    TriggerClientEvent("qb-jobs:client:updateBlips",-1, dutyPlayers, publicPlayers)
end
--- Sends Email to Phones
local sendEmail = function(mail)
    local mailData = {}
    mailData.sender = mail.sender
    mailData.subject = mail.subject
    mailData.message = mail.message
    mailData.button = {}
    exports["qb-phone"]:sendNewMailToOffline(mail.recCitID, mailData)
end
--- Submits Job Applications
local submitApplication = function(res, jgType)
    local msg, history
    local src = res.src
    local player = QBCore.Functions.GetPlayer(src)
    local metaData = player.PlayerData.metadata
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    local conf = cdata.conf
    local pd = cdata.pd
    local citid = player.PlayerData.citizenid
    local charInfo = player.PlayerData.charinfo
    local data = {
        ["error"] = {},
        ["success"] = {},
    }
    local ercnt = 0
    local jgData = {
        [pd.type] = res[pd.type]:lower(),
        ["newGradeLevel"] = 0,
        ["newGradeLevelName"] = "No Grades",
        ["history"] = nil
    }
    if metaData[pd.history][jgData[pd.type]] then jgData.history = metaData[pd.history][jgData[pd.type]] end
    local jobInfo = Config[jgType][res[pd.type]]
    local gender = Lang:t('email.mr')
    if charInfo.gender == 1 then
        gender = Lang:t('email.mrs')
    end
    local hData = {
        ["src"] = res.src,
        ["citid"] = citid,
        [pd.type] = jgData[pd.type],
        [jgData[pd.type]] = {
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
        [pd.history] = metaData[pd.history],
        ["isOnline"] = true
    }
    if metaData[pd.types][jgData[pd.type]] then
        data.error[0] = {
            ["subject"] = "Already Employed",
            ["msg"] = string.format("%s %s is already employed in %s", charInfo.firstname, charInfo.firstname, jgData[pd.type]),
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
    if jgData.history and jgData.history.status == "pending" then
        data.error[0] = {
            ["subject"] = "Application Pending",
            ["msg"] = string.format("%s %s is application pending in %s", charInfo.firstname, charInfo.lastname, jgData[pd.type]),
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
    if jgData.history and not jgData.history.rehireable then
        data.error[0] = {
            ["subject"] = "Application Refused",
            ["msg"] = string.format("%s %s is blackListed in %s", charInfo.firstname, charInfo.firstname, jgData[pd.type]),
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
        if res.grade then jgData.newGradeLevel = res.grade end
        if tonumber(jgData.newGradeLevel) ~= 0 then jgData.newGradeLevelName = jobInfo.grades[jgData.newGradeLevel].name end
        if jobInfo.jobBosses and not jobInfo.jobBosses[citid] then
            hData[hData[pd.type]].applycount += 1
            hData[hData[pd.type]].status = "pending"
            hData[hData[pd.type]].details[hData.index.details] = string.format("applied for %s", jgData[pd.type])
            hData.index.details += 1
            data.citid = citid
            data.sender = Lang:t('email.jobAppSender',{firstname = charInfo.firstname, lastname = charInfo.lastname})
            data.subject = Lang:t('email.jobAppSub',{lastname = charInfo.lastname, job = res.job})
            data.message = Lang:t('email.jobAppMsg',{gender = gender, lastname = charInfo.lastname, job = res.job, firstname = charInfo.firstname, phone = charInfo.phone})
            data.success[ercnt] = {
                ["subject"] = "Application Submitted",
                ["msg"] = Lang:t('info.new_job_app',{job = jobInfo.label}),
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
                    SetTimeout(math.random(1000, 2000),function()
                        data.recCitID = k
                        sendEmail(data)
                    end)
                end)
            end
        elseif not jobInfo.jobBosses or jobInfo.jobBosses[citid] then
            jgData.newGradeLevel = "1"
            jgData.newGradeLevelName = Config[jgType][jgData[pd.type]].grades[jgData.newGradeLevel].name
            if jobInfo.jobBosses then
                local tmp = 1
                while Config[jgType][jgData[pd.type]].grades[tmp] do
                    jgData.newGradeLevel = tmp
                    tmp += 1
                end
                jgData.newGradeLevelName = Config[jgType][jgData[pd.type]].grades[jgData.newGradeLevel].name
            end
            jgData.newGradeLevel = tostring(jgData.newGradeLevel)
            hData[hData[pd.type]].status = "hired"
            hData[hData[pd.type]].hiredcount += 1
            hData[hData[pd.type]].grades[hData.index.grades] = jgData.newGradeLevel
            hData.index.grades += 1
            hData[hData[pd.type]].details[hData.index.details] = string.format("Hired on as %s", jgData.newGradeLevelName)
            hData.index.details += 1
            player.Functions[pd.set](jgData[pd.type], jgData.newGradeLevel)
            player = QBCore.Functions.GetPlayer(src)
            player.Functions[pd.add](player.PlayerData[pd.type].name, player.PlayerData[pd.type])
            player = QBCore.Functions.GetPlayer(src)
            data.success[ercnt] = {
                ["subject"] = string.format("%s New Hire!", jgData[pd.type]),
                ["msg"] = string.format("Hired onto %s as %s", jgData[pd.type], jgData.newGradeLevelName),
                ["jsMsg"] = string.format("Hired onto %s as %s", jgData[pd.type], jgData.newGradeLevelName),
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
    history = processHistory(hData, jgType)
    if history and history.error then
        return history
    end
    if pd.type == "job" then player.Functions.AddToJobHistory(hData[pd.type], history) end
    if pd.type == "gang" then player.Functions.AddToGangHistory(hData[pd.type], history) end
    player = QBCore.Functions.GetPlayer(src)
    data.player = player
    return data
end
exports("submitApplication", submitApplication)
--- Send jobs to city hall
local sendToCityHall = function()
    local isManaged, toCH
    for k, v in pairs(Config.Jobs) do
        isManaged = false
        if v.jobBosses then isManaged = true end
        if v.listInCityHall then
            toCH = {
                ["label"] = v.label,
                ["isManaged"] = isManaged
            }
            exports['qb-cityhall']:AddCityJob(k, toCH)
        end
    end
end
--- sends MotorworksConfig table to qb-customs
local sendToCustoms = function()
    local data = {}
    for k, v in pairs(Config.Jobs) do
        data[k] = v.MotorworksConfig
    end
    exports["qb-customs"]:buildLocations(data)
end
--- Generates list to pupulate the boss menu
local buildManagementData = function(src, jgType)
    local personal, hList, sql, queryResult
    local player = QBCore.Functions.GetPlayer(src)
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    local conf = cdata.conf
    local pd = cdata.pd
    local jg = cdata.jg
    local players = QBCore.Functions.GetQBPlayers()
    local jobCheck = {}
    local plist = {}
    local hData = {}
    local societyAccounts = exports["qb-banking"]:sendSocietyAccounts(src, pd.name)
    local mgrBtnList = {
        ["players"] = {},
        ["jobs"] = {},
        ["gangs"] = {},
        ["error"] = {},
        ["success"] = {},
        ["jg"] = jg,
        ["pd"] = pd
    }
    local pending = function(v, k1)
        mgrBtnList[pd.types][k1].applicants = {}
        mgrBtnList[pd.types][k1].applicants[v.citid] = {}
        mgrBtnList[pd.types][k1].applicants[v.citid].personal = personal
        if pd.type == "job" then
            mgrBtnList[pd.types][k1].applicants[v.citid].history = hList
            if v.metadata.rapsheet then mgrBtnList.jobs[k1].applicants[v.citid].rapSheet = v.metadata.rapsheet end
        end
    end
    local hired = function(v, k1)
        personal.position = v.metadata[pd.types][k1].grade
        if k1 == pd.name and v.metadata[pd.types] and v.metadata[pd.types][k1] then
            if pd.type == "job" then personal.payRate = v.metadata.jobs[k1].payment end
        end
        mgrBtnList[pd.types][k1][pd.label] = {}
        mgrBtnList[pd.types][k1][pd.label][v.citid] = {}
        mgrBtnList[pd.types][k1][pd.label][v.citid].personal = personal
        if pd.type == "job" then
            mgrBtnList[pd.types][k1][pd.label][v.citid].history = hList
            if v.metadata.rapsheet then mgrBtnList.jobs[k1][pd.label][v.citid].rapSheet = v.metadata.rapsheet end
        end
    end
    local quit = function(v, k1)
        mgrBtnList[pd.types][k1][pd.pastLabel] = {}
        mgrBtnList[pd.types][k1][pd.pastLabel][v.citid] = {}
        mgrBtnList[pd.types][k1][pd.pastLabel][v.citid].personal = personal
        if pd.type == "job" then
            mgrBtnList[pd.types][k1][pd.pastLabel][v.citid].history = hList
            if v.metadata.rapsheet then mgrBtnList.jobs[k1][pd.pastLabel][v.citid].rapSheet = v.metadata.rapsheet end
        end
    end
    local denied = function(v, k1)
        mgrBtnList[pd.types][k1].deniedApplicants[v.citid] = {}
        mgrBtnList[pd.types][k1].deniedApplicants[v.citid].personal = personal
        if pd.type == "job" then
            mgrBtnList[pd.types][k1].deniedApplicants[v.citid].history = hList
            if v.metadata.rapsheet then mgrBtnList.jobs[k1].deniedApplicants[v.citid].rapSheet = v.metadata.rapsheet end
        end
    end
    local buildSQL = function()
        sql = {
            ["query"] = string.format("SELECT `citizenid` AS 'citid',`charinfo`,`metadata`,`license` FROM `players` WHERE JSON_VALUE(`metadata`,'$.%shistory.%s.status') != 'available'", pd.type, jg.name),
            ["from"] = "qb-jobs/server/main.lua > function > buildManagementData"
        }
        return sql
    end
    local status = {
        ["pending"] = {["func"] = pending},
        ["hired"] = {["func"] = hired},
        ["quit"] = {["func"] = quit},
        ["fired"] = {["func"] = quit},
        ["blacklisted"] = {["func"] = quit},
        ["denied"] = {["func"] = denied}
    }
    sql = buildSQL()
    queryResult = sqlHandler(sql)
    if queryResult.error and next(queryResult.error) then return queryResult end
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
            hData.citid = v.citid
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
            hList = v.metadata[pd.history]
            if not hList or not next(hList) then hList = processHistory(hData, jgType) end
            if Config.hideAvailableJobs then
                hList = nil
                hList = {}
                for k1, v1 in pairs(v.metadata[pd.history]) do
--                    hList[k1] = v1
--                    if v1.status == "available" then hList[k1] = nil end
                    if v1.status ~= "available" then hList[k1] = v1 end
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
            if v.metadata and v.metadata[pd.history] then
                for k1, v1 in pairs(v.metadata[pd.history]) do
                    if not jobCheck[k1] then
                        jobCheck[k1] = true
                        mgrBtnList[pd.types][k1] = {
                            ["applicants"] = {},
                            [pd.label] = {},
                            [pd.pastLabel] = {},
                            ["deniedApplicants"] = {},
                            ["society"] = {
                                ["balance"] = comma_value(societyAccounts.accounts[k1])
                            },
                            ["config"] = {
                                ["currencySymbol"] = QBCore.Config.Money.CurrencySymbol
                            }
                        }
                    end
                    if v1.status ~= "available" then
                        mgrBtnList[pd.types][k1] = {}
                        status[v1.status].func(v, k1)
                    end
                end
            end
        end
    else
        mgrBtnList.error[0] = {
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
--- Staff / Member Manager for Gang and Job Boss
local manageStaff = function(res, jgType)
    local awrep = tonumber(1)
    if res.awrep then
        awrep = tonumber(res.awrep)
        if not QBCore.Functions.PrepForSQL(src, awrep, "^%d+$") then
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
    local mgrBtnList = buildManagementData(src, jgType)
    if not mgrBtnList then
        output.error[0] = {
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
        output.error[0] = {
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
    local managerGang = manager.PlayerData.gang
    local mcdata =  selectJobGang(jgType, managerJob, managerGang)
    local mconf = mcdata.conf
    local mjg = mcdata.jg
    local md = mcdata.pd -- employer job (also employee job)
    local staff = setUnderlingStatus(res)
    local metaData = staff.player.PlayerData.metadata
    local staffData = metaData.jobs[managerJob.name]
    if md.type == "gang" then
        staffData = nil
        staffData = metaData.gangs[managerGang.name]
    end
    if not staffData then
        staffData = {
            ["grade"] = {["level"] = 1}
        }
    end
    local data = {
        ["citid"] = citid,
        ["job"] = md.name,
        ["staff"] = {
            ["data"] = staff,
            ["citid"] = citid,
            ["job"] = staffData.name
        },
        ["manager"] = {
            ["data"] = manager,
            ["src"] = src,
            ["citid"] = manager.PlayerData.citizenid,
            ["job"] = mjg.name,
        }
    }
    local approveManagerAction = function(info)
        local grade = info.approve.grade
        local gradeName = mjg.grades[grade].name
        local deets = "hired onto"
        data.prevJob = md.name
        data.newJob = md.name
        if md.type == "gang" then
            deets = "jumped into"
            data.prevGang = md.name
            data.newGang = md.name
        end
        data.grade = grade
        data.gradeName = gradeName
        data[md.name] = {
            ["hiredcount"] = 1,
            ["details"] = {string.format("was %s %s", deets, md.name)},
            ["status"] = "hired"
        }
        output = setJobGang(data, jgType)
        if output.error and next(output.error) then return output end
        output.success[0] = {
            ["subject"] = string.format("Approval Alert"),
            ["msg"] = string.format("%s was approved with %s.", citid, md.name),
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
        data[md.name] = {
            ["denycount"] = 1,
            ["details"] = {string.format("was denied in %s", md.name)},
            ["status"] = "denied"
        }
        local history = processHistory(data, jgType)
        if staff.isOnline then
            output = staff.player.Functions.AddToJobHistory(md.name, jobHistory)
            return output
        end
        metaData[md.history][md.name] = history
        sql = {
            ["query"] = string.format("UPDATE `players` SET `metadata` = '%s' WHERE `citizenid` = '%s'", json.encode(metaData),citid),
            ["from"] = "qb-jobs/server/main.lua > function > manageStaff > denyManagerAction > "
        }
        queryResult = sqlHandler(sql)
        if queryResult.error and next(queryResult.error) then return queryResult end
        if output.error and next(output.error) then return output end
        output.success[0] = {
            ["subject"] = string.format("Denial Alert"),
            ["msg"] = string.format("%s was denied with %s.", citid, md.name),
            ["jsMsg"] = string.format("%s was denied with %s.", citid, md.name),
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
        local new = {
            [md.type] = "unemployed"
        }
        local prev = {
            [md.type] = md.name
        }
        data.prevJob = prev[md.type]
        data.newJob = new[md.type]
        if md.type == "gang" then
            md.name = "none"
            data.prevGang = prev[md.type]
            data.newGang = new[md.type]
        end
        prev[md.type] = pd.name
        local gradeName = Config[jgType][md.name].grades[grade].name
        data.grade = grade
        data.gradeName = gradeName
        data[md.type] = prev[md.type]
        data[prev[md.type]] = {
            ["firedcount"] = 1,
            ["details"] = {string.format("was terminated from %s", prevName)},
            ["status"] = "fired"
        }
        output = setJobGang(data, jgType)
        if output.error and next(output.error) then return output end
        output.success[0] = {
            ["subject"] = string.format("Termination Alert"),
            ["msg"] = string.format("%s was Terminated from %s", citid, prevName),
            ["jsMsg"] = string.format("Terminated from %s", prevName),
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
        if not mjg.grades[grade] then
            output.error[0] = {
                ["subject"] = string.format("Can't %s Any Further", res.action),
                ["msg"] = string.format("%s can not be %s any further in %s.", citid, res.action, jobName),
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
        local gradeName = mjg.grades[grade].name
        local prevGradeName = mjg.grades[prevGrade].name
        data.grade = grade
        data.gradeName = gradeName
        data.prevJob = md.name
        data.newJob = md.name
        if md.type == "gang" then
            data.prevGang = md.name
            data.newGang = md.name
        end
        data[md.name] = {
            ["gradechangecount"] = 1,
            ["details"] = {string.format("was %s from %s to %s", info[res.action].details, prevGradeName, gradeName)}
        }
        output = setJobGang(data, jgType)
        if output.error and next(output.error) then return output end
        output.success[0] = {
            ["subject"] = string.format("%s Alert", info[res.action].subject),
            ["msg"] = string.format("%s in %s.", info[res.action].details, jobName),
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
        data[md.name] = {
            ["details"] = {string.format("was reconsidered in %s", md.name)},
            ["status"] = info.reconsider.status
        }
        local history = processHistory(data, jgType)
        staff = setUnderlingStatus(res)
        if staff.isOnline then
            output = staff.player.Functions[md.addHistory](md.name, history)
        else
            metaData[md.history][md.name] = history
            sql = {
                ["query"] = string.format("UPDATE `players` SET `metadata` = '%s' WHERE `citizenid` = '%s'", json.encode(metaData),citid),
                ["from"] = "qb-jobs/server/main.lua > function > > manageStaff > reconsiderManagerAction"
            }
            queryResult = sqlHandler(sql)
            if queryResult.error and next(queryResult.error) then return queryResult end
            output.success[0] = {
                ["subject"] = string.format("Reconsideration Alert"),
                ["msg"] = string.format("%s was reconsidered with %s.", citid, md.name),
                ["jsMsg"] = string.format("%s was reconsidered with %s.", citid, md.name),
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
        if not QBCore.Functions.PrepForSQL(src, payRate, "^%d+$") then
            output.error[0] = true
            return output
        end
        local history = processHistory(data, jgType)
        local jgData = metaData[md.types][md.name]
        jgData.payment = payRate
        if staff.isOnline then
            output = staff.player.Functions.AddToJobHistory(md.name, history)
            if output.error and next(output.error) then return output end
            output = staff.player.Functions.AddToJobs(md.name, jgData)
            if output.error and next(output.error) then return output end
            if staffData.name == md.name then staff.player.Functions.UpdateJob(jgData) end
            if output.error and next(output.error) then return output end
            output = setUnderlingStatus(res)
            return output
        else
            metaData[md.history][md.name] = history
            metaData[md.types][md.name] = jgData
            if staffData.name == md.name then
                staffData = nil
                staffData = jgData
            end
            sql = {
                ["query"] = string.format("UPDATE `players` SET `job` = '%s',`metadata` = '%s' WHERE `citizenid` = '%s'", json.encode(staffData),json.encode(metaData),citid),
                ["from"] = "qb-jobs/server/main.lua > function > manageStaff > payMangerAction"
            }
            queryResult = sqlHandler(sql)
            if queryResult.error and next(queryResult.error) then return queryResult end
            data.player = QBCore.Player.GetOfflinePlayer(citid)
        end
        if data.error and next(data.error) then return data end
        data.success[0] = {
            ["subject"] = string.format("Pay Adjustment Alert"),
            ["msg"] = string.format("%s pay was adjusted to %s in %s.", data.citid, payRate, md.name),
            ["jsMsg"] = string.format("%s pay was adjusted to %s in %s.", data.citid, payRate, md.name),
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
        data[md.name] = {
            ["details"] = {string.format('%s was %s: %s in %s', citid, info[res.action].details, info[res.action].awrep, md.name)},
            [info[res.action].confs] = {info[res.action].awrep},
            ["status"] = "hired"
        }
        local history = processHistory(data, jgType)
        if staff.isOnline then
            output = staff.player.Functions[md.addHistory](md.name, history)
            if output.error and next(output.error) then return output end
            output = setUnderlingStatus(res)
            return output
        else
            metaData[md.history][md.type] = history
            sql = {
                ["query"] = string.format("UPDATE `players` SET `metadata` = '%s' WHERE `citizenid` = '%s'", json.encode(metaData),citid),
                ["from"] = "qb-jobs/server/main.lua > function > manageStaff > awrepManagerAction"
            }
            queryResult = sqlHandler(sql)
            if queryResult.error and next(queryResult.error) then return queryResult end
            data.player = QBCore.Player.GetOfflinePlayer(citid)
        end
        if data.error and next(data.error) then return data end
        data.success[0] = {
            ["subject"] = string.format("%s Alert", info[res.action].subject),
            ["msg"] = string.format('%s was %s: "%s" in %s', citid, info[res.action].details, info[res.action].awrep, md.name),
            ["jsMsg"] = string.format('was %s: "%s"', info[res.action].details, info[res.action].awrep),
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
            ["prevGrade"] = staffData.grade.level,
            ["newGrade"] = tonumber(staffData.grade.level) + 1,
            ["grade"] = tonumber(staffData.grade.level) + 1,
            ["details"] = "promoted",
            ["subject"] = "Promotion",
            ["func"] = gradeManagerAction
        },
        ["demote"] = {
            ["status"] = "demote",
            ["prevGrade"] = staffData.grade.level,
            ["newGrade"] = tonumber(staffData.grade.level) - 1,
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
            ["awrep"] = cdata.management.awards[awrep].title,
            ["details"] = "awarded",
            ["subject"] = "Award",
            ["confs"] = "awards",
            ["func"] = awrepManagerAction
        },
        ["reprimand"] = {
            ["awrep"] = cdata.management.reprimands[awrep].title,
            ["details"] = "reprimanded",
            ["subject"] = "Reprimand",
            ["confs"] = "reprimands",
            ["func"] = awrepManagerAction
        },
    }
    output = data.action[res.action].func(data.action)
    return output
end
--- Function to add player to job or gang using command /setjob or /setgang
local commandJobGang = function(src, res, jgType)
    local label = res.label
    local grade = res.grade
    local player = QBCore.Functions.GetPlayer(tonumber(res.pid))
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local conf = selectJobGang(jgType, playerJob, playerGang)
    local citid = player.PlayerData.citizenid
    local output = {
        ["manager"] = {["src"] = src},
        ["label"] = label,
        ["grade"] = grade,
        ["citid"] = citid,
        ["appcid"] = citid,
        ["action"] = "approve",
        ["success"] = {},
        ["error"] = {}
    }
    if player then
        local deets = {
            ["Jobs"] = {
                ["deet"] = "hired onto",
                ["prevKey"] = "prevJob",
                ["newKey"] = "newJob"
            },
            ["Gangs"] = {
                ["deet"] = "jumped onto",
                ["prevKey"] = "prevGang",
                ["newKey"] = "newGang"
            },
        }
        local data = {
            [deets[jgType].prevKey] = label,
            [deets[jgType].newKey] = label,
            ["grade"] = grade,
            ["gradeName"] = Config[jgType].grades[grade].name,
            [label] = {
                ["hiredcount"] = 1,
                ["details"] = {string.format("was %s %s", deets[jgType].deet, label)},
                ["status"] = "hired"
            }
        }
        output = setJobGang(data, jgType)
        if output.error and next(output.error) then return output end
        output.success[0] = {
            ["subject"] = string.format("Approval Alert"),
            ["msg"] = string.format("%s was approved with %s.", citid, md.name),
            ["jsMsg"] = string.format("%s was approved.", citid),
            ["src"] = src,
            ["color"] = "notice",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["notify"] = true
        }
        errorHandler(output.success)
        return output
    else
        TriggerClientEvent('QBCore:Notify', source, Lang:t('error.not_online'),'error')
    end
end
--- function to verify data coming in for /setjob and /setgang
local verifyCommandSetJobGangVars = function(src, args, jgType)
    local admin = QBCore.Functions.GetPlayer(tonumber(src))
    local license = admin.PlayerData.license
    local output = {
        ["Jobs"] = {
            ["grademsg"] = "/setjob",
            ["labelinvalid"] = "Job Name is Invalid",
            ["labelmsg"] = "Job Name is Invalid /setjob",
            ["labelmiss"] = "Job does not exist!",
            ["labelmissmsg"] = "Job does not exist /setjob"
        },
        ["Gangs"] = {
            ["grademsg"] = "/setjob",
            ["labelinvalid"] = "Job Name is Invalid",
            ["labelmsg"] = "Job Name is Invalid /setjob",
            ["labelmiss"] = "Job does not exist!",
            ["labelmissmsg"] = "Job does not exist /setjob"
        },
        ["success"] = {},
        ["error"] = {},
    }
    if not QBCore.Functions.PrepForSQL(src, pid, "^%d+$") then
        output.error[ercnt] = {
            ["subject"] = "Player ID is Invalid",
            ["msg"] = string.format("Player ID is invalid /setjob used by: %s", license),
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        return output
    end
    if not QBCore.Functions.PrepForSQL(src, label, "^%a+$") then
        output.error[ercnt] = {
            ["subject"] = output[jgType].labelinvalid,
            ["msg"] = string.format("%s used by: %s", output[jgType].labelmsg, license),
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        return output
    end
    if not QBCore.Functions.PrepForSQL(src, grade, "^%d+$") then
        output.error[ercnt] = {
            ["subject"] = "Grade is Invalid",
            ["msg"] = string.format("Grade is invalid %s used by: %s", output[jgType].grademsg, license),
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        return output
    end
    if not Config[jgType][label] or not next(Config[jgType][label]) then
        output.error[ercnt] = {
            ["subject"] = output[jgType].labelmiss,
            ["msg"] = string.format("%s used by: %s", output[jgType].labelmissmsg, license),
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        return output
    end
    if not Config[jgType][label].grades[grade] or not next(Config[jgType][label].grades[grade]) then
        output.error[ercnt] = {
            ["subject"] = "Grade does not Exist",
            ["msg"] = string.format("Grade does not exist %s used by: %s", output[jgType].grademsg, license),
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        return output
    end
    if not IsPlayerAceAllowed(src, "admin") then
        output.error[0] = {
            ["subject"] = "Player is Not Admin",
            ["msg"] = string.format("%s is not an admin and attempted to add player to job: %s", player.PlayerData.license, args[2]),
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        return output
    end
    local player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if not player and not next(player) then
        output.error[0] = {
            ["subject"] = "Player is Not Online!",
            ["msg"] = "Player is not online!",
            ["color"] = "notify",
            ["notify"] = true
        }
        errorHandler(output.error)
        return output
    end
    output.pid = args[1]
    output.label = args[2]
    output.grade = args[3]
    return output
end
--- functions to run at resource start
local kickOff = function()
    CreateThread(function() checkUniqueJobGang() end)
    CreateThread(function() sendWebHooks() end)
    CreateThread(function() countVehPop() end)
    CreateThread(function() sendToCityHall() end)
    CreateThread(function() sendToCustoms() end)
    CreateThread(function() MySQL.query("DELETE FROM stashitems WHERE stash LIKE '%trash%'") end)
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
    for _,v in pairs(players) do
        if v and v.PlayerData.job.type == 'leo' and v.PlayerData.job.onduty then
            local alertData = {title = Lang:t('info.new_call'),coords = {x = coords.x, y = coords.y, z = coords.z},description = text}
            TriggerClientEvent("qb-phone:client:Alert", v.PlayerData.source, alertData)
            TriggerClientEvent('qb-jobs:client:Alert', v.PlayerData.source, coords, text)
        end
    end
end)
--- Event to Build History Data
RegisterServerEvent("qb-jobs:server:BuildHistory", function(jgType)
    local output = {["src"] = source}
    local player = QBCore.Functions.GetPlayer(output.src)
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local conf = selectJobGang(jgType, playerJob, playerGang)
    local pd = conf.pd
    local ph = {
        ["Jobs"] = player.PlayerData.metadata.jobhistory,
        ["Gangs"] = player.PlayerData.metadata.ganghistory,
    }
    local history
    for k in pairs(Config[jgType]) do
        if not ph[jgType] or not ph[jgType][k] or not next(ph[jgType][k]) then
            output[pd.type] = k
            history = {
                ["firedcount"] = 0,
                ["applycount"] = 0,
                ["denycount"] = 0,
                ["hiredcount"] = 0,
                ["gradechangecount"] = 0,
                ["quitcount"] = 0,
                ["reprimands"] = {},
                ["awards"] = {},
                ["grades"] = {},
                ["details"] = {},
                ["rehireable"] = true,
                ["status"] = "available"
            }
            if type == "Jobs" then player.Functions.AddToJobHistory(k, history) end
            if type == "Gangs" then player.Functions.AddToGangHistory(k, history) end
        end
    end
end)
--- Event to call the populateJobsNGangs function from client
RegisterServerEvent('qb-jobs:server:populateJobsNGangs', function()
    local src = source
    populateJobsNGangs(src)
end)
--- Event to add items to vehicle
RegisterServerEvent('qb-jobs:server:addVehItems', function(data, jgType)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    local SetCarItemsInfo = function(data)
        local items = {}
        local index = 1
        if cdata.Items[data.inv] then
            for _,v in pairs(cdata.Items[data.inv]) do
                local vehType = false
                local authGrade = false
                for _,v1 in pairs(v.vehType) do
                    if v1 == cdata.Vehicles.vehicles[data.vehicle].type then
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
--- Event to open the shop by eventually calling an export
RegisterServerEvent('qb-jobs:server:openShop', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    populateJobsNGangs(src) -- ensures client has latest QBCore.Shared.Jobs table.
    local index = 1
    local inv = {
        label = cdata.Items.shopLabel,
        slots = 30,
        items = {}
    }
    local items = cdata.Items.items
    for key = 1,#items do
        for key2 = 1,#items[key].authorizedJobGrades do
            for key3 = 1,#items[key].locations do
                if items[key].locations[key3] == "shop" and items[key].authorizedJobGrades[key2] == playerJob.grade.level then
                    if items[key].type == "weapon" then items[key].info.serie = tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4)) end
                    inv.items[index] = items[key]
                    inv.items[index].slot = index
                    index = index + 1
                end
            end
        end
    end
    TriggerEvent("inventory:server:OpenInventory", "shop", playerJob.name, inv)
end)
--- Event to open the stashes by calling an export
RegisterServerEvent("qb-jobs:server:openStash", function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local stashHeading = string.format("%s%s", playerJob.name, player.PlayerData.citizenid)
    exports['qb-inventory']:OpenInventory("stash", stashHeading, false, source)
    TriggerClientEvent("inventory:client:SetCurrentStash", stashHeading)
end)
--- Event to open the trash by calling an export
RegisterServerEvent('qb-jobs:server:openTrash', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local options = {
        ["maxweight"] = 4000000,
        ["slots"] = 300
    }
    local stashHeading = string.format("%s-%s-%s", playerJob.name, Lang:t('headings.trash'),player.PlayerData.citizenid)
    exports['qb-inventory']:OpenInventory("stash", stashHeading, options, source)
    TriggerClientEvent("inventory:client:SetCurrentStash", stashHeading)
end)
--- Initilizes the Vehicle Tracker for the client.
RegisterServerEvent('qb-jobs:server:initilizeVehicleTracker', function()
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    vehTrack = {[player.PlayerData.citizenid] = {}}
end)
--- adds vehicles to job total
RegisterServerEvent('qb-jobs:server:addVehicle', function(jgType)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    local jg = cdata.jg
    vehCount[jg.name] += 1
end)
-- Deletes Vehicle from the server
RegisterServerEvent("qb-jobs:server:deleteVehicleProcess", function(result, jgType)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    local citid = player.PlayerData.citizenid
    local vehList = cdata.Vehicles
    if not vehTrack[citid][result.plate].selGar == "motorpool" and vehTrack[citid][result.plate].veh and not DoesEntityExist(NetworkGetEntityFromNetworkId(vehTrack[citid][result.plate].veh)) then
        TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Fake Refund Attempt', 'red', string.format('%s attempted to obtain a refund for returned vehicle!', GetPlayerName(src)))
        return false
    end
    if vehTrack[citid][result.plate].selGar == "motorpool" and vehList.config.depositFees and not result.noRefund and vehList.vehicles[result.vehicle].depositPrice then
        if player.Functions.AddMoney("cash", vehList.vehicles[result.vehicle].depositPrice, pd.name .. Lang:t("success.depositFeesPaid",{value = vehList.vehicles[result.vehicle].depositPrice})) then
            TriggerClientEvent('QBCore:Notify', src, Lang:t("success.depositReturned",{value = vehList.vehicles[result.vehicle].depositPrice}),"success")
            TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Refund Deposit Success', 'green', string.format('%s received a refund of %s for returned vehicle!', GetPlayerName(src),vehList.vehicles[result.vehicle].depositPrice))
            exports['qb-management']:RemoveMoney(pd.name, vehList.vehicles[result.vehicle].depositPrice)
        end
    end
    vehCount[pd.name] -= 1
    vehTrack[citid][result.plate] = nil
end)
--- Error Event Handler
RegisterServerEvent("qb-jobs:server:errorHandler", function(error)
    errorHandler(error)
end)
-- Callbacks
--- Verifies the vehicle count
QBCore.Functions.CreateCallback("qb-jobs:server:verifyMaxVehicles", function(source, cb, jgType)
    local test = true
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then cb(false) end
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    local conf = cdata.conf
    local pd = cdata.pd
    local jg = cdata.jg
    if conf.Vehicles.config.maxVehicles > 0 and conf.Vehicles.config.maxVehicles <= vehCount[jg.name] then
        QBCore.Functions.Notify(Lang:t("info.vehicleLimitReached"))
        test = false
    end
    cb(test)
end)
--- Processes Vehicles to be issued
QBCore.Functions.CreateCallback("qb-jobs:server:spawnVehicleProcessor", function(source, cb, result, jgType)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    local conf = cdata.conf
    local vehList = conf.Vehicles
    local total = 0
    local message = {}
    local ownGarage = function()
        if vehList.config.ownedParkingFee and vehList.vehicles[result.vehicle].parkingPrice then
            total += vehList.vehicles[result.vehicle].parkingPrice
            message.msg = Lang:t("success.parkingFeesPaid",{value = vehList.vehicles[result.vehicle].parkingPrice})
        end
    end
    local jobStore = function()
        local output = {
            ["src"] = src,
            ["vehicle"] = result.vehicle,
            ["plate"] = result.plate,
            ["type"] = type
        }
        exports['qb-vehicleshop']:BuyJobsVehicle(output)
    end
    local motorpool = function()
        if vehList.config.rentalFees and vehList.vehicles[result.vehicle].rentPrice then
            total += vehList.vehicles[result.vehicle].rentPrice
            message.rent = Lang:t("success.rentalFeesPaid",{value = vehList.vehicles[result.vehicle].rentPrice})
        end
        if vehList.config.depositFees and vehList.vehicles[result.vehicle].depositPrice then
            total += vehList.vehicles[result.vehicle].depositPrice
            message.deposit = Lang:t("success.depositFeesPaid",{value = vehList.vehicles[result.vehicle].depositPrice})
        end
        if message.rent and message.deposit then message.msg = message.rent .. " " .. message.deposit
        elseif message.rent then message.msg = message.rent
        elseif message.deposit then message.msg = message.deposit end
    end
    local default = function()
        TriggerClientEvent('QBCore:Notify', source, Lang.t("denied.invalidGarage"),"denied")
        TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Intrusion Attempted', 'red', string.format('%s attempted to obtain a vehicle!', GetPlayerName(source)))
        return false
    end
    local selGar = {
        ["ownGarage"] = ownGarage,
        ["jobStore"] = jobStore,
        ["motorpool"] = motorpool,
        ["default"] = default,
    }
    selGar[result.selGar]()
    if total > 0 then
        if not player.Functions.RemoveMoney("bank", total, message.msg) then
            if not player.Functions.RemoveMoney("cash", total, message.msg) then
                TriggerClientEvent('QBCore:Notify', source, Lang:t("error.not_enough",{value = total}),"error")
                return false
            end
        end
        exports['qb-management']:AddMoney(pd.name, total)
    end
    TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'Money Received!', 'green', string.format('%s received money!', GetPlayerName(source)))
    if(not vehTrack[player.PlayerData.citizenid]) then vehTrack[player.PlayerData.citizenid] = {} end
    vehTrack[player.PlayerData.citizenid][result.plate] = {
        ["veh"] = result.veh,
        ["netid"] = result.netid,
        ["vehicle"] = result.vehicle,
        ["selGar"] = result.selGar
    }
    cb(true)
end)
--- Creates plates and ensures they are not in-use
QBCore.Functions.CreateCallback("qb-jobs:server:vehiclePlateCheck", function(source, cb, res, jgType)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    local conf = cdata.conf
    local plate, vehProps, ppl, sql, queryResult
    local pplMax = 4
    res.platePrefix = conf.Vehicles.config.plate
    ppl = string.len(res.platePrefix)
    if ppl > pplMax then
        res.platePrefix = string.sub(res.platePrefix, 1,pplMax)
        print("^1Your plate prefix is " .. ppl .. " must be less than ".. pplMax .. " chracters at: qb-jobs/jobs/" .. pd.name .. ".lua >>> VehicleConfig > Plate^7")
    end
    ppl = 7 - ppl
    res.min = 1 .. string.rep("0", ppl)
    res.max = 9 .. string.rep("9", ppl)
    res.vehTrack = vehTrack[player.PlayerData.citizenid]
    plate = exports["qb-vehicleshop"]:JobsPlateGen(res)
    if res.selGar == "ownGarage" then
        sql = {
            ["query"] = string.format("SELECT `mods` FROM `player_vehicles` WHERE `plate` = '%s'", plate),
            ["from"] = "qb-jobs/server/main.lua > callback > vehiclePlateCheck"
        }
        queryResult = sqlHandler(sql)
        if queryResult.error and next(queryResult.error) then return queryResult end
        if queryResult[1] then vehProps = json.decode(queryResult[1].mods) end
    end
    cb(plate, vehProps)
end)
--- Generates list to populate the vehicle selector menu
QBCore.Functions.CreateCallback('qb-jobs:server:sendGaragedVehicles', function(source, cb, data, jgType)
    local player = QBCore.Functions.GetPlayer(source)
    if not player then return false end
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    local conf = cdata.conf
    local pd = cdata.pd
    local jg = cdata.jg
    local grade = tonumber(jg.grade.level)
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
    vehList.uiColors = conf.uiColors
    vehList.label = pd.label
    vehList.icons = conf.menu.icons
    vehList.garage = data
    vehList.header = pd.label .. Lang:t('headings.garages')
    for _,v in pairs(conf.Locations.garages[data].spawnPoint) do
        typeList[v.type] = true
    end
    for k, v in pairs(conf.Vehicles.vehicles) do
        for _,v1 in pairs(v.authGrades) do
            if(v1 == grade and typeList[v.type]) then
                vehList.vehicles[v.type] = {
                    [index[v.type]] = {
                        ["spawn"] = k,
                        ["label"] = v.label,
                        ["icon"] = v.icon,
                    }
                }
                if conf.Vehicles.config.depositFees then vehList.vehicles[v.type][index[v.type]].depositPrice = v.depositPrice  end
                if conf.Vehicles.config.rentalFees then vehList.vehicles[v.type][index[v.type]].rentPrice = v.rentPrice  end
                if v.purchasePrice and conf.Vehicles.config.allowPurchase then
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
                if v.parkingPrice and conf.Vehicles.config.allowPurchase and conf.Vehicles.config.ownedParkingFee then
                    vehList.vehicles[v.type][index[v.type]].parkingPrice = v.parkingPrice
                    vehList.vehiclesForSale[v.type][index[v.type]].parkingPrice = v.parkingPrice
                end
                index[v.type] += 1
            end
        end
    end
    index.boat = 1
    index.helicopter = 1
    index.plane = 1
    index.vehicle = 1
    if conf.Vehicles.config.ownedVehicles then
        vehList.allowPurchase = true
    end
    sql = {
        ["query"] = string.format("SELECT `plate`,`vehicle` FROM `player_vehicles` WHERE `citizenid` = '%s' AND `state` = '%s' AND `%s` = '%s'", player.PlayerData.citizenid, 0,pd.type, pd.name),
        ["from"] = "qb-jobs/server/main.lua > callback > sendGaragedVehicles"
    }
    queryResult = sqlHandler(sql)
    if queryResult.error and next(queryResult.error) then
        cb(queryResult)
        return queryResult
    end
    for _,v in pairs(queryResult) do
        vehShort = conf.Vehicles.vehicles[v.vehicle]
        for _,v1 in pairs(vehShort.authGrades) do
            if(v1 == grade and typeList[vehShort.type]) then
                if not vehList.ownedVehicles[vehShort.type] then vehList.ownedVehicles[vehShort.type] = {} end
                vehList.ownedVehicles[vehShort.type][index[vehShort.type]] = {
                    ["plate"] = v.plate,
                ["spawn"] = v.vehicle,
                    ["label"] = conf.Vehicles.vehicles[v.vehicle].label,
                    ["icon"] = conf.Vehicles.vehicles[v.vehicle].icon
                }
                if(vehShort.parkingPrice) then vehList.ownedVehicles[vehShort.type][index[vehShort.type]].parkingPrice = vehShort.parkingPrice end
                index[vehShort.type] += 1
            end
        end
    end
    cb(vehList)
end)
--- Sends Management Data to populate the boss menu
QBCore.Functions.CreateCallback('qb-jobs:server:sendManagementData', function(source, cb, data, jgType)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    local pd = cdata.pd
    local jg = cdata.jg
    local mgrBtnList = buildManagementData(src, jgType)
    cb(mgrBtnList[pd.types][jg.name])
    return mgrBtnList
end)
--- Processes management actions from the boss menu
QBCore.Functions.CreateCallback("qb-jobs:server:processManagementSubMenuActions", function(source, cb, res, jgType)
    local src = source
    local manager = QBCore.Functions.GetPlayer(src)
    local managerJob = manager.PlayerData.job
    local managerGang = manager.PlayerData.gang
    local cdata =  selectJobGang(jgType, managerJob, managerGang)
    local conf = cdata.conf
    local pd = cdata.pd
    local managerLicense = manager.PlayerData.license
    local ercnt = 0
    local output = {
        ["error"] = {}
    }
    local mgrBtnList = buildManagementData(src, jgType)
    res.manager = {
        ["src"] = src
    }
    if not mgrBtnList.players[res.appcid] then
        output.error[ercnt] = {
            ["subject"] = "Player Data Missing",
            ["msg"] = string.format("Player data missing; Boss Menu used by: ?", res.appcid),
            ["jsMsg"] = "Player Data Missing",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        cb(output)
        return output
    end
    res.citid = res.appcid
    if not QBCore.Functions.PrepForSQL(src, res.action, "^%a+$") then
        output.error[ercnt] = {
            ["subject"] = "Action Data Invalid",
            ["msg"] = string.format("Action data Invalid Boss Menu used by: ?", managerLicense),
            ["jsMsg"] = "Action Data Invalid",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        cb(output)
        return output
    end
    output = manageStaff(res)
    if not output or output.error and next(output.error) then
        cb(output)
        return output
    end
    if not mgrBtnList or mgrBtnList.error and next(mgrBtnList.error) then
        cb(mgrBtnList)
        return mgrBtnList
    end
    cb(mgrBtnList[pd.types][pd.name])
    return mgrBtnList
end)
--- Processes society actions from the boss menu
QBCore.Functions.CreateCallback("qb-jobs:server:processManagementSocietyActions", function(source, cb, res, jgType)
    local src = source
    local manager = QBCore.Functions.GetPlayer(src)
    local managerJob = manager.PlayerData.job
    local managerGang = player.PlayerData.gang
    local cdata =  selectJobGang(jgType, managerJob, managerGang)
    local conf = cdata.conf
    local pd = cdata.pd
    local mgrBtnList = buildManagementData(src, jgType)
    local managerLicense = manager.PlayerData.license
    local ercnt = 0
    local output = {
        ["error"] = {}
    }
    if not QBCore.Functions.PrepForSQL(src, res.depwit, "^%d+$") then
        output.error[ercnt] = {
            ["subject"] = "Amount is Invalid",
            ["msg"] = string.format("Amount is invalid boss menu used by: %s", managerLicense),
            ["jsMsg"] = "Amount is Invalid",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        cb(output)
        return output
    end
    output = exports["qb-banking"]:societyDepwit(src, res.depwit, res.selector)
    if not mgrBtnList or mgrBtnList.error and next(mgrBtnList.error) then
        cb(mgrBtnList)
        return mgrBtnList
    end
    cb(mgrBtnList[pd.types][pd.name])
    return mgrBtnList
end)
--- Processes multiJob menu items
QBCore.Functions.CreateCallback("qb-jobs:server:processMultiJob", function(source, cb, res)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local playerJob = player.PlayerData.job
    local playerGang = player.PlayerData.gang
    local jgType = res.type
    local cdata =  selectJobGang(jgType, playerJob, playerGang)
    local conf = cdata.conf
    local pd = cdata.pd
    local jg = cdata.jg
    local playerJobs = player.PlayerData.metadata.jobs
    local playerGangs = player.PlayerData.metadata.gangs
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
    local gangCheck = function(data)
        if not playerGangs[data.gang] then
            output.error[ercnt] = {
                ["subject"] = "Is not a Member!!",
                ["msg"] = string.format("player does not exist in processMultiJob Callback! #msg002"),
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
    pd.job = {["check"] = jobCheck}
    pd.gang = {["check"] = gangCheck}
    local activate = function(data)
        local output = {
            ["error"] = {},
            ["success"] = {}
        }
        if not pd[pd.type].check(data) then return false end
        player.Functions[pd.active](jg)
        return output
    end
    local quit = function(data)
        local output = {
            ["src"] = src,
            ["citid"] = data.citid,
            [pd.type] = data[pd.type],
            [data[pd.type]] = {
                ["status"] = "quit",
                ["details"] = {[1] = "Resigned"},
                ["quitcount"] = 1
            },
            ["error"] = {},
            ["success"] = {}
        }
        local history = processHistory(output, jgType)
        if not pd[pd.type].check(data) then return false end
        player.Functions[pd.addHistory](data[pd.type], history)
        if data[pd.type] == pd.type then player.Functions[pd.set](pd.civilian, "0") end
        player.Functions[pd.remove](res[pd.type])
        output.success[0] = {
            ["subject"] = "User Resigned",
            ["msg"] = string.format("%s resigned from %s", player.PlayerData.citizenid, pd.name),
            ["jsMsg"] = "User Resigned!",
            ["color"] = "success",
            ["logName"] = conf.webHooks[playerJob.name],
            ["src"] = src,
            ["log"] = true,
            ["notify"] = true
        }
        player = QBCore.Functions.GetPlayer(src)
        playerJob = player.PlayerData.job
        playerGang = player.PlayerData.gang
        cdata =  selectJobGang(jgType, playerJob, playerGang)
        conf = cdata.conf
        pd = cdata.pd
        jg = cdata.jg
        QBCore.Debug(cdata)
        QBCore.Debug(jg)
        player.Functions[pd.active](jg)
        return output
    end
    local apply = function(data)
        local output = {
            ["src"] = data.src,
            [pd.type] = data[pd.type],
            ["citid"] = data.citid,
            ["grade"] = 0,
            ["error"] = {},
            ["success"] = {}
        }
        output = submitApplication(output, jgType)
        return output
    end
    local output = {
        ["error"] = {},
        ["success"] = {}
    }
    local action = {
        ["activate"] = {["func"] = activate},
        ["quit"] = {["func"] = quit},
        ["apply"] = {["func"] = apply},
    }
    if not QBCore.Functions.PrepForSQL(src, res.action, "^%a+$") then
        output.error[0] = {
            ["subject"] = "Action is Invalid",
            ["msg"] = string.format("Action is invalid multi-job menu used by: %s", player.PlayerData.license),
            ["jsMsg"] = "Action is Invalid",
            ["color"] = "error",
            ["logName"] = "qbjobs",
            ["src"] = src,
            ["log"] = true,
            ["console"] = true
        }
        errorHandler(output.error)
        cb(output)
        return output
    end
    if not QBCore.Functions.PrepForSQL(src, res[pd.type], "^%a+$") then
            output.error[0] = {
                ["subject"] = "Job is Invalid",
                ["msg"] = string.format("Job is invalid multiJob menu used by: %s", player.PlayerData.license),
                ["jsMsg"] = "Job is Invalid",
                ["color"] = "error",
                ["logName"] = "qbjobs",
                ["src"] = src,
                ["log"] = true,
                ["console"] = true
            }
            errorHandler(output.error)
            cb(output)
            return output
    end
    output[pd.type] = res[pd.type]
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
QBCore.Commands.Add("duty", Lang:t("command.duty"),{},false, function(source)
    local src = source
    TriggerClientEvent('qb-jobs:client:toggleDuty', src)
end, QBCore.duty)
--- Creates the /jobs command to open the multi-jobs menu.
QBCore.Commands.Add("jobs", Lang:t("command.jobs"),{},false, function(source)
    local src = source
    TriggerClientEvent('qb-jobs:client:multiJobMenu', src)
end)
--- Checks Job Status of Player
QBCore.Commands.Add('job', Lang:t("command.job.help"),{},false, function(source)
    local PlayerJob = QBCore.Functions.GetPlayer(source).PlayerData.job
    TriggerClientEvent('QBCore:Notify', source, Lang:t('info.job_info',{value = PlayerJob.label, value2 = PlayerJob.grade.name, value3 = PlayerJob.onduty}))
end, 'user')
--- Assigns a Player to a job and grade
QBCore.Commands.Add('setjob', Lang:t("command.setjob.help"),{ { name = Lang:t("command.setjob.params.id.name"),help = Lang:t("command.setjob.params.id.help") },{ name = Lang:t("command.setjob.params.job.name"),help = Lang:t("command.setjob.params.job.help") },{ name = Lang:t("command.setjob.params.grade.name"),help = Lang:t("command.setjob.params.grade.help") } },true, function(source, args)
    local src = source
    local jgType = "Jobs"
    local output = verifyCommandSetJobGangVars(src, args, jgType)
    if not output.error or not next(output.error) then
        commandJobGang(src, output, jgType)
    end
    return true
end, 'admin')
--- Creates the /gangs command to open the multi-gangs menu.
QBCore.Commands.Add("gangs", Lang:t("command.gangs"),{},false, function(source)
    local src = source
    TriggerClientEvent('qb-jobs:client:multiJobMenu', src)
end)
--- Checks Gang Status of Player
QBCore.Commands.Add('gang', Lang:t("command.gang.help"),{},false, function(source)
    local PlayerGang = QBCore.Functions.GetPlayer(source).PlayerData.gang
    TriggerClientEvent('QBCore:Notify', source, Lang:t('info.gang_info',{value = PlayerGang.label, value2 = PlayerGang.grade.name}))
end, 'user')
--- Assigns a Player to a gang and grade
QBCore.Commands.Add('setgang', Lang:t("command.setgang.help"),{ { name = Lang:t("command.setgang.params.id.name"),help = Lang:t("command.setgang.params.id.help") },{ name = Lang:t("command.setgang.params.gang.name"),help = Lang:t("command.setgang.params.gang.help") },{ name = Lang:t("command.setgang.params.grade.name"),help = Lang:t("command.setgang.params.grade.help") } },true, function(source, args)
    local src = source
    local jgType = "Gangs"
    local output = verifyCommandSetJobGangVars(src, args, jgType)
    if not output.error or not next(output.error) then commandJobGang(src, output, jgType) end
    return true
end, 'admin')