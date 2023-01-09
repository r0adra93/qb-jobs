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
--- Counts Number of Vehicles a given Job has assigned.
local vehCount = {}
--- Tracks all vehicles spawned by players
local vehTrack = {}
--- key is the job name and value is the job label
-- local jobsList = {}
--- Populates  the server side QBCore.Shared.Jobs table at resource start
exports['qb-core']:AddJobs(Config.Jobs)
-- Functions
--- Populates the server side QBCore.Shared.Jobs table
local function errorHandler(error)
    for _,v in pairs(error) do
        if v.notify then TriggerClientEvent('QBCore:Notify', v.src, v.msg, v.type) end
        if v.log then TriggerEvent('qb-log:server:CreateLog', v.resource, v.subject, v.color, v.msg) end
        if v.console then print(color.bg.red, color.fg.white, string.format("%s %s %s - %s", v.resource, v.msg)) end
        if v.kick then DropPlayer(src, Lang:t("admin.kick%s",v.pmsg)) end
        if v.ban then exports["qb-adminmenu"]:BanPlayer(v.src) end
    end
end
local function populateJobs(src)
    CreateThread(function()
        exports['qb-core']:AddJobs(Config.Jobs)
        for k,v in pairs(Config.Jobs) do
            TriggerClientEvent('QBCore:Client:OnSharedUpdate', src, "Jobs", k, v)
        end
    end)
end
exports('populateJobs',populateJobs)
--- Checks if underling is online
local function setUnderlingStatus(res)
    local data = {
        ["isOnline"] = false
    }
    if not res.citid or mgrBtnList.players[res.citid].source then
        if mgrBtnList.players[res.citid] and mgrBtnList.players[res.citid].source then res.src = mgrBtnList.players[res.citid].source end
        data.player = QBCore.Functions.GetPlayer(res.src)
        data.isOnline = true
    else
        data.player = QBCore.Functions.GetPlayerByCitizenId(res.citid)
        data.isOnline = true
    end
    if not data.player then data.isOnline = false end
    return data
end
--- Sets the job up for the underling
local function setJob(res)
    local data = setUnderlingStatus(res)
    local player = data.player
    local job, grade, queryResult, rtnError
    local pD = {
        ["job"] = {},
        ["citid"] = res.citid
    }
    if data.isOnline then player.Functions.SetJob(res.job, res.grade)
    else
        job = res.job:lower()
        grade = tostring(res.grade)
        if not QBCore.Shared.Jobs[job] then return false end
        pD.job.name = job
        pD.job.label = QBCore.Shared.Jobs[job].label
        pD.job.onduty = QBCore.Shared.Jobs[job].defaultDuty
        pD.job.type = QBCore.Shared.Jobs[job].type
        local jobGrade = Config.Jobs[job].grades[grade]
        pD.job.grade = {}
        pD.job.grade.name = jobGrade.name
        pD.job.grade.level = tostring(grade)
        pD.job.payment = jobGrade.payment
        pD.metadata = mgrBtnList.players[pD.citid].metadata
        if not pD.metadata.jobs then pD.metadata.jobs = {} end
        pD.metadata.jobs[job] = {}
        if job ~= "unemployed" then
            for k,v in pairs(pD.job) do
                pD.metadata.jobs[job][k] = v
            end
        end
        queryResult = MySQL.update.await('UPDATE players SET job = ?, metadata = ? WHERE citizenid = ?',{json.encode(pD.jo),json.encode(pD.metadata),pD.citid}, function(result)
            if next(result) then
                cb(result)
            else
                cb(nil)
            end
        end)
        if queryResult then
            TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'JobHistory Update Success', 'green', string.format('%s job history was successfully updated!', pD.citid))
            return rtnError
        else
            TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'JobHistory Update Failed', 'red', string.format('%s job history was not updated!', pD.citid))
            rtnError = "Data did not Save"
            return rtnError
        end
    end
    return rtnError
end
--- Prepares data for the buildJobHistory function for the current player
local function processJobHistory(jhData)
    --- Builds the Job History metadata table.
    local function buildJobHistory(jhData)
        local jobHistory = jhData.jobHistory
        local player = jhData.player
        local queryResult
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
        if jhData.prePop then
            for k in pairs(Config.Jobs) do
                if not jobHistory[k] then
                    jobHistory[k] = jhList
                end
            end
        elseif jhData.pop then
            if jhData.reprimands then
                if jobHistory[jhData.job].reprimands then
                    for k,v in pairs(jobHistory[jhData.job].reprimands) do
                        jhList.reprimands[k] = v
                        index.reprimands += 1
                    end
                end
                if index.reprimands == 0 then index.reprimands = 1 end
                for _,v in pairs(jhData.reprimands) do
                    jhList.reprimands[index.reprimands] = v
                    index.reprimands += 1
                end
            elseif jobHistory[jhData.job].reprimands then
                jhList.reprimands = jobHistory[jhData.job].reprimands
            end
            if jhData.awards then
                if jobHistory[jhData.job].awards then
                    for k,v in pairs(jobHistory[jhData.job].awards) do
                        jhList.awards[k] = v
                        index.awards += 1
                    end
                end
                if index.awards == 0 then index.awards = 1 end
                for _,v in pairs(jhData.awards) do
                    jhList.awards[index.awards] = v
                    index.awards += 1
                end
            elseif jobHistory[jhData.job].awards then
                jhList.awards = jobHistory[jhData.job].awards
            end
            if jhData.details then
                if jobHistory[jhData.job].details then
                    for k,v in pairs(jobHistory[jhData.job].details) do
                        jhList.details[k] = v
                        index.details += 1
                    end
                end
                if index.details == 0 then index.details = 1 end
                for _,v in pairs(jhData.details) do
                    jhList.details[index.details] = v
                    index.details += 1
                end
            elseif jobHistory[jhData.job].details then
                jhList.details = jobHistory[jhData.job].details
            end
            if jhData.grades then
                if jobHistory[jhData.job].grades then
                    for k,v in pairs(jobHistory[jhData.job].grades) do
                        jhList.grades[k] = v
                        index.grades += 1
                    end
                end
                if index.grades == 0 then index.grades = 1 end
                for _,v in pairs(jhData.grades) do
                    jhList.grades[index.grades] = v
                    index.grades += 1
                end
            elseif jobHistory[jhData.job].grades then
                jhList.grades = jobHistory[jhData.job].grades
            end
            if not jhData.gradechangecount then jhData.gradechangecount = 0 end
            if not jhData.firedcount then jhData.firedcount = 0 end
            if not jhData.hiredcount then jhData.hiredcount = 0 end
            if not jhData.quitcount then jhData.quitcount = 0 end
            if not jhData.denycount then jhData.denycount = 0 end
            if not jhData.applycount then jhData.applycount = 0 end
            if jhData.status then jhList.status = jhData.status end
            if jobHistory[jhData.job].gradechangecount then jhList.gradechangecount = jhData.gradechangecount + jobHistory[jhData.job].gradechangecount end
            if jobHistory[jhData.job].firedcount then jhList.firedcount = jhData.firedcount + jobHistory[jhData.job].firedcount end
            if jobHistory[jhData.job].hiredcount then jhList.hiredcount = jhData.hiredcount + jobHistory[jhData.job].hiredcount end
            if jobHistory[jhData.job].quitcount then jhList.quitcount = jhData.quitcount + jobHistory[jhData.job].quitcount end
            if jobHistory[jhData.job].denycount then jhList.denycount = jhData.denycount + jobHistory[jhData.job].denycount end
            if jobHistory[jhData.job].applycount then jhList.applycount = jhData.applycount + jobHistory[jhData.job].applycount end
            jobHistory[jhData.job] = {
                ["status"] = jhList.status,
                ["rehireable"] = jhList.rehireable,
                ["reprimands"] = jhList.reprimands,
                ["awards"] = jhList.awards,
                ["details"] = jhList.details,
                ["gradechangecount"] = jhList.gradechangecount,
                ["firedcount"] = jhList.firedcount,
                ["hiredcount"] = jhList.hiredcount,
                ["quitcount"] = jhList.quitcount,
                ["denycount"] = jhList.denycount,
                ["applycount"] = jhList.applycount,
            }
        end
        if jhData.isOnline then
            player.Functions.SetMetaData("jobhistory", jobHistory)
            QBCore.Player.Save(jhData.src)
        else
            if jhData.citid and mgrBtnList.players[jhData.citid] then mgrBtnList.players[jhData.citid].metadata.jobhistory = jobHistory end
            queryResult = MySQL.update.await('UPDATE players SET metadata = ? WHERE citizenid = ?',{json.encode(mgrBtnList.players[jhData.citid].metadata),jhData.citid}, function(result)
                if next(result) then
                    cb(result)
                else
                    cb(nil)
                end
            end)
            if queryResult then TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'JobHistory Update Success', 'green', string.format('%s job history was successfully updated!', jhData.citid))
            else TriggerEvent('qb-log:server:CreateLog', 'qbjobs', 'JobHistory Update Failed', 'red', string.format('%s job history was not updated!', jhData.citid)) end
        end
        return true
    end
    local data = setUnderlingStatus(jhData)
    jhData.isOnline = data.isOnline
    jhData.player = data.player
    if not jhData.jobHistory and jhData.player and jhData.player.PlayerData.metadata.jobhistory then jhData.jobHistory = jhData.player.PlayerData.metadata.jobhistory end
    jhData.prePop = false
    jhData.pop = false
    if Config.Jobs[jhData.job] then
        if not jhData.jobHistory or not jhData.jobHistory[jhData.job] then
            jhData.prePop = true
            buildJobHistory(jhData)
            processJobHistory(jhData)
            jhData.prePop = false
        end
        jhData.pop = true
        buildJobHistory(jhData)
        return true
    end
    return false
end
exports("processJobHistory",processJobHistory)
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
    SetTimeout(math.random(2500, 4000), function()
        mailData.sender = mail.sender
        mailData.subject = mail.subject
        mailData.message = mail.message
        mailData.button = {}
        exports["qb-phone"]:sendNewMailToOffline(mail.recCitID, mailData)
    end)
end
--- Submits Job Applications
local function submitApplication(res)
    local player = QBCore.Functions.GetPlayer(res.src)
    local playerJob = player.PlayerData.job
    local mgrData = {
        ["citid"] = {},
        ["job"] = {},
        ["jobName"] = {}
    }
    local data = {
        ["error"] = {},
    }
    local ercnt = 0
    if not mgrBtn.players[citid] then
        data.error[ercnt] = {
            ["subject"] = "Exploit Attempt: submitApplication",
            ["msg"] = string.format("%s attempted to exploit the fire feature", player.PlayerData.license),
            ["color"] = "red",
            ["resource"] = "qb-jobs",
            ["log"] = true,
            ["console"] = true
        }
        ercnt += 1
    end
    if res.citid ~= player.PlayerData.citizenid then
        local manager = player
        mgrData.citid = manager.PlayerData.citizenid
        mgrData.job = manager.PlayerData.job
        mgrData.jobName = manager.PlayerData.job.name
        player = {
            PlayerData = {
                ["job"] = mgrBtnList.players[res.citid].jobs[mgrData.job.name],
                ["metadata"] = mgrBtnList.players[res.citid].metadata,
                ["charinfo"] = mgrBtnList.players[res.citid].charinfo
            }
        }
    end
    local jobData = {
        ["newJob"] = res.job:lower(),
        ["newGrade"] = 0,
        ["newJobGrade"] = "No Grades",
        ["newJobHistory"] = nil,
        ["currentJob"] = playerJob.name:lower(),
        ["currentGrade"] = tonumber(playerJob.grade.level),
        ["currentJobGrade"] = playerJob.grade.name,
    }
    if player.PlayerData.metadata.jobhistory[jobData.newJob] then jobData.newJobHistory = player.PlayerData.metadata.jobhistory[jobData.newJob] end
    local citid = player.PlayerData.citizenid
    local charInfo = player.PlayerData.charinfo
    local jobInfo = Config.Jobs[res.job]
    local gender = Lang:t('email.mr')
    if charInfo.gender == 1 then
        gender = Lang:t('email.mrs')
    end
    local msg
    local jhData = {
        ["src"] = res.src,
        ["job"] = jobData.newJob,
        ["details"] = {},
        ["grades"] = {},
        ["status"] = "available",
        ["gradechange"] = 0,
        ["applycount"] = 0,
        ["hiredcount"] = 0,
        ["index"] = {
            ["details"] = 1,
            ["grades"] = 1
        }
    }
    local cjhData = {
        ["src"] = res.src,
        ["job"] = jobData.currentJob,
        ["status"] = "available",
        ["details"] = {},
        ["gradechange"] = 0,
        ["applycount"] = 0,
        ["index"] = {
            ["details"] = 1,
        }
    }
    if player.PlayerData.metadata.jobs[jobData.newJob] then
        TriggerClientEvent('QBCore:Notify', res.src, "Already Employed")
        data.error[ercnt] = {
            ["subject"] = "Already Employed",
            ["msg"] = string.format("%s %s is already employed", player.PlayerData.charinfo.firstname, player.PlayerData.charinfo.firstname),
            ["color"] = "green",
            ["resource"] = "qb-jobs",
            ["log"] = true
        }
        ercnt += 1
    end
    if jobData.newJobHistory and jobData.newJobHistory.status and jobData.newJobHistory.status == "pending" then
        TriggerClientEvent('QBCore:Notify', res.src, "Application Pending")
        data.error[ercnt] = {
            ["subject"] = "Already Applied",
            ["msg"] = string.format("%s %s is already applied", player.PlayerData.charinfo.firstname, player.PlayerData.charinfo.firstname),
            ["color"] = "green",
            ["resource"] = "qb-jobs",
            ["log"] = true
        }
        ercnt += 1
    end
    if jobData.newJobHistory and not jobData.newJobHistory.rehireable then
        TriggerClientEvent('QBCore:Notify', res.src, "Application Refused")
        data.error[ercnt] = {
            ["subject"] = "Application Refused",
            ["msg"] = string.format("%s %s is blackListed", player.PlayerData.charinfo.firstname, player.PlayerData.charinfo.firstname),
            ["color"] = "green",
            ["resource"] = "qb-jobs",
            ["log"] = true
        }
        ercnt += 1
    end
    if not next(data.error) and jobInfo then
        if res.grade then jobData.newGrade = res.grade end
        if tonumber(jobData.newGrade) ~= 0 then jobData.newJobGrade = jobInfo.grades[jobData.newGrade].name end
        if res.quit or res.fired then
            if res.quit then
                cjhData.status = "quit"
                cjhData.details[cjhData.index.details] = "Quit their job."
                cjhData.quitcount += 1
                cjhData.index.details += 1
                data.msg = "You quit From " .. jobData.currentJob
            elseif res.fired then
                if mgrData.citid then
                    cjhData.status = "fired"
                    cjhData.details[cjhData.index.details] = "Fired from their job."
                    cjhData.quitcount += 1
                    cjhData.index.details += 1
                    data.msg = "Terminated From " .. jobData.currentJob
                else
                    data.error[ercnt] = {
                        ["subject"] = "Exploit Attempt: submitApplication",
                        ["msg"] = string.format("%s attempted to exploit the fire feature", player.PlayerData.license),
                        ["color"] = "red",
                        ["resource"] = "qb-jobs",
                        ["log"] = true,
                        ["console"] = true
                    }
                end
            end
            jobData.newJob = "unemployed"
            jobData.newGrade = 0
        elseif jobData.newJob == jobData.currentJob or player.PlayerData.metadata.jobs[jobData.newJob] then
            if mgrData.citid then -- this if statement prevents unmanaged jobs from filling up the metadata.
                if tonumber(jobData.newGrade) > tonumber(jobData.currentGrade) then jhData.details[jhData.index.details] = string.format("promotion from %s to %s",jobData.currentJobGrade, jobData.newJobGrade)
                elseif tonumber(jobData.newGrade) < tonumber(jobData.currentGrade) then jhData.details[jhData.index.details] = string.format("demotion from %s to %s", jobData.currentJobGrade, jobData.newJobGrade)
                else jhData.details[jhData.index.details] = "Position remained the same" end
                jhData.index.details += 1
                jhData.gradechange += 1
                jhData.status = "hired"
            end
        elseif not jobInfo.jobBosses and not player.PlayerData.metadata.jobs[jobData.newJob] then
            jhData.details[jhData.index.details] = "was hired by " .. jobData.newJob
            jhData.index.details += 1
            jhData.hiredcount += 1
            jhData.status = "hired"
        elseif res.resub or jobInfo.jobBosses and not jobInfo.jobBosses.players[citid] then
            jhData.applycount += 1
            jhData.status = "pending"
            if res.resub then
                jhData.details[jhData.index.details] = res.resub
                jhData.index.details += 1
            else
                msg = Lang:t('info.new_job_app', {job = jobInfo.label})
                data.citid = citid
                data.sender = Lang:t('email.jobAppSender', {firstname = charInfo.firstname, lastname = charInfo.lastname})
                data.subject = Lang:t('email.jobAppSub', {lastname = charInfo.lastname, job = res.job})
                data.message = Lang:t('email.jobAppMsg', {gender = gender, lastname = charInfo.lastname, job = res.job, firstname = charInfo.firstname, phone = charInfo.phone})
                TriggerClientEvent('QBCore:Notify', res.src, msg)
                for k in pairs(jobInfo.jobBosses) do
                    data.recCitID = k
                    sendEmail(data)
                end
            end
        elseif not jobInfo.jobBosses or jobInfo.jobBosses[citid] then
            if jobInfo.jobBosses then
                jobData.newGrade = 0
                for _ in pairs(jobInfo.grades) do
                    jobData.newGrade += 1
                end
                jobData.newGrade = tostring(jobData.newGrade)
                jobData.newJobGrade = jobInfo.grades[jobData.newGrade].name
            end
        else
            data.error[ercnt] = {
                ["subject"] = "Exploit Attempt: Boss Menu!",
                ["msg"] = string.format("%s attempted to exploit the Boss Menu", player.PlayerData.license),
                ["color"] = "red",
                ["resource"] = "qb-jobs",
                ["log"] = true,
                ["console"] = true
            }
        end
    end
    if not next(data.error) and jobData.newJob and jobData.newGrade and data.citid then
        data.job = jobData.newJob
        data.grade = jobData.newGrade
        data.citid = citid
        TriggerClientEvent('QBCore:Notify', res.src, data.msg)
        setJob(data)
        processJobHistory(jhData)
        processJobHistory(cjhData)
        return true
    end
    errorHandler(data.error[ercnt])
    return false
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
    if not player then return false end
    local playerJob = player.PlayerData.job
    local players = QBCore.Functions.GetQBPlayers()
    local jobCheck = {}
    local plist = {}
    local jhList = {}
    local personal
    local sqlQuery = "$.jobhistory." .. playerJob.name .. ".status";
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
            ["metadata"] = v.PlayerData.metadata,
            ["charinfo"] = v.PlayerData.charinfo,
            ["source"] = v.PlayerData.source,
            ["license"] = v.PlayerData.license
        }
    end
    if queryResult then
        for _,v in pairs(queryResult) do
            mgrBtnList.players[v.citid] = {}
            if plist[v.citid] then
                v.metadata = plist[v.citid].metadata
                v.charinfo = plist[v.citid].charinfo
                v.source = plist[v.citid].source
                v.license = plist[v.citid].license
            else
                v.metadata = json.decode(v.metadata)
                v.charinfo = json.decode(v.charinfo)
            end
            if Config.hideUnWorkedJobs then
                jhList = nil
                jhList = {}
                for k1,v1 in pairs(v.metadata.jobhistory) do
                    if v1.status ~= "available" then jhList[k1] = v1 end
                end
                v.metadata.jobhistory = nil
                v.metadata.jobhistory = jhList
            end
            mgrBtnList.players[v.citid].metadata = v.metadata
            mgrBtnList.players[v.citid].charinfo = v.charinfo
            mgrBtnList.players[v.citid].license = v.license
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
                        mgrBtnList.jobs[k1].applicants[v.citid].jobHistory = v.metadata.jobhistory
                        if v.metadata.rapsheet then mgrBtnList.jobs[k1].applicants[v.citid].rapSheet = v.metadata.rapsheet end
                    elseif v1.status == "hired" then
                        if v.metadata.jobs and v.metadata.jobs[k1] then personal.position = v.metadata.jobs[k1].grade end
                        mgrBtnList.jobs[k1].employees[v.citid] = {}
                        mgrBtnList.jobs[k1].employees[v.citid].personal = personal
                        mgrBtnList.jobs[k1].employees[v.citid].jobHistory = v.metadata.jobhistory
                        if v.metadata.rapsheet then mgrBtnList.jobs[k1].employees[v.citid].rapSheet = v.metadata.rapsheet end
                    elseif v1.status == "quit" or v1.status == "fired" or v1.status == "blacklisted" then
                        mgrBtnList.jobs[k1].pastEmployees[v.citid] = {}
                        mgrBtnList.jobs[k1].pastEmployees[v.citid].personal = personal
                        mgrBtnList.jobs[k1].pastEmployees[v.citid].jobHistory = v.metadata.jobhistory
                        if v.metadata.rapsheet then mgrBtnList.jobs[k1].pastEmployees[v.citid].rapSheet = v.metadata.rapsheet end
                    elseif v1.status == "denied" then
                        mgrBtnList.jobs[k1].deniedApplicants[v.citid] = {}
                        mgrBtnList.jobs[k1].deniedApplicants[v.citid].personal = personal
                        mgrBtnList.jobs[k1].deniedApplicants[v.citid].jobHistory = v.metadata.jobhistory
                        if v.metadata.rapsheet then mgrBtnList.jobs[k1].deniedApplicants[v.citid].rapSheet = v.metadata.rapsheet end
                    end
                end
            end
        end
    end
end
--- functions to run at resource start
local function kickOff()
    CreateThread(function()
        countVehPop()
        sendToCityHall()
        verifySociety()
        sendToCustoms()
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
            MySQL.query("DELETE FROM stashitems WHERE stash LIKE '%trash%'")
        end)
    end
end)
--- OnPlayerLoaded QBCore Event
RegisterServerEvent('QBCore:Client:OnPlayerLoaded', function()
    kickOff()
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
    local player = QBCore.Functions.GetPlayer(src)
    local playerJob = player.PlayerData.job
    local data = {
        ["citid"] = res.appcid,
        ["job"] = playerJob.name,
        ["src"] = src,
        ["error"] = {}
    }
    local ercnt = 0
    buildManagementData(src)
    local e = mgrBtnList.jobs[playerJob.name].employees[data.citid]
    local a = mgrBtnList.jobs[playerJob.name].applicants[data.citid]
    local pe =  mgrBtnList.jobs[playerJob.name].pastEmployees[data.citid]
    local pa =  mgrBtnList.jobs[playerJob.name].deniedApplicants[data.citid]
    if not e or not a or not pe or not pa then
        data.error[ercnt] = {
            ["subject"] = "Exploit Attempt: Boss Menu",
            ["msg"] = string.format("%s attempted to exploit the boss system", player.PlayerData.license),
            ["color"] = "red",
            ["resource"] = "qb-jobs",
            ["log"] = true,
            ["console"] = true
        }
        ercnt += 1
    end
    if not next(data.error) then
        if res.action == "approve" then
            data.grade = 1
        elseif res.action == "terminate" then
            data.fired = true
            data.grade = 0
            data.job = "unemployed"
        elseif res.action == "resign" then
            data.quit = true
            data.grade = 0
            data.job = "unemployed"
        elseif res.action == "promote" then
            data.grade = mgrBtnList.players[res.appcid].metadata.jobs[playerJob.name].grade.level
            data.grade = tonumber(data.grade) + 1
            data.grade = tostring(data.grade)
            if not Config.Jobs[playerJob.name].grades[data.grade] then
                data.error[ercnt] = {
                    ["subject"] = "Promotion Message",
                    ["msg"] = "Max Grade Reached",
                    ["color"] = "green",
                    ["resource"] = "qb-jobs",
                    ["src"] = src,
                    ["log"] = true,
                    ["console"] = true,
                    ["notify"] = true,
                }
                ercnt += 1
            end
        elseif res.action == "demote" then
            data.grade = mgrBtnList.players[res.appcid].metadata.jobs[playerJob.name].grade.level
            data.grade = tonumber(data.grade) - 1
            data.grade = tostring(data.grade)
            if not Config.Jobs[playerJob.name].grades[data.grade] then
                data.error[ercnt] = {
                    ["msg"] = "Lowest Grade Reached",
                    ["type"] = "error",
                    ["notify"] = true,
                    ["src"] = src
                }
                ercnt += 1
            end
        elseif res.action == "apply" then
            if mgrBtnList.jobs[playerJob.name].deniedApplicants[res.appcid] then
                data.resub = "Application ReSubmitted by Admin"
            else
                data.error[ercnt] = {
                    ["subject"] = "Exploit Attempt: Boss Menu",
                    ["msg"] = string.format("%s attempted to exploit the boss menu apply feature",player.PlayerData.license),
                    ["color"] = "red",
                    ["log"] = true,
                    ["console"] = true,
                    ["src"] = src
                }
                ercnt += 1
            end
        else
            data.error[ercnt] = {
                ["subject"] = "Exploit Attempt: Boss Menu",
                ["msg"] = string.format("%s attempted to exploit the boss menu feature",player.PlayerData.license),
                ["color"] = "red",
                ["log"] = true,
                ["console"] = true,
                ["src"] = src
            }
            ercnt += 1
        end
    end
    if next(data.error) then
        errorHandler(data.error)
        cb(data)
    end
    if submitApplication(data) then
        buildManagementData(src)
        cb(mgrBtnList.jobs[playerJob.name])
    end
    cb(false)
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
--- calls kickOff at resource start
kickOff()