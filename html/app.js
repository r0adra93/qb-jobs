/* Variables */
let btnList = [];
let btnCnt = 0;
let Lang = [];
let action = "";
let dbgmsg = "";
/* Variables for Testing */
/** Garage **/
/* btnList = {"header":"Medical Services Vehicle Manager","icons":{"helicopter":"fa-solid fa-helicopter","vehicle":"fa-solid fa-truck-medical","retract":"fa-solid fa-angles-left","plane":"fa-solid fa-plane","close":"fa-regular fa-circle-xmark","boat":"fa-solid fa-ship","ownGarage":"fa-solid fa-warehouse","jobGarage":"fa-solid fa-square-parking","returnVehicle":"fa-solid fa-rotate-left","jobStore":"fa-solid fa-store"},"ownedVehicles":{"helicopter":{"0":{"icon":"fa-solid fa-helicopter","plate":"EMS54321","parkingPrice":125,"label":"Maverick","purchasePrice":1000,"spawn":"polmav"}},"vehicle":{"0":{"icon":"fa-solid fa-truck-medical","plate":"EMS12345","parkingPrice":125,"label":"Ambulance","purchasePrice":1000,"spawn":"ambulance"}}},"allowPurchase":true,"vehicles":{"helicopter":[{"rentPrice":250,"parkingPrice":125,"icon":"fa-solid fa-helicopter","label":"Air Ambulance","purchasePrice":3000000,"spawn":"polmav"}],"vehicle":[{"rentPrice":250,"icon":"fa-solid fa-truck-medical","parkingPrice":125,"label":"Ambulance","depositPrice":250,"purchasePrice":150000,"spawn":"ambulance"}]},"vehiclesForSale":{"helicopter":[{"icon":"fa-solid fa-helicopter","parkingPrice":125,"purchasePrice":3000000,"label":"Air Ambulance","spawn":"polmav"}],"vehicle":[{"icon":"fa-solid fa-truck-medical","parkingPrice":125,"purchasePrice":150000,"label":"Ambulance","spawn":"ambulance"}]},"garage":1,"label":"Medical Services","returnVehicle":{"1370114":"ambulance","1369090":"ambulance","1364226":"ambulance","1364738":"ambulance","1366530":"ambulance","1365762":"ambulance","1363970":"ambulance"}};
btnList = btnList;
btnList.icons.retract = "fa-solid fa-angles-left";
/** Management **/
/** Management **/
/*** Unfiltered jobHistory ***/
/* btnList = {"pastEmployees":[],"employees":{"SPC88576":{"rapSheet":[],"jobHistory":{"bus":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"taxi":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"mechanic":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"lawyer":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"garbage":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"vineyard":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"unemployed":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"cardealer":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"trucker":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"reporter":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"realestate":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"ambulance":{"firedcount":0,"denycount":0,"hiredcount":2,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"hired"},"police":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"judge":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"hotdog":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"tow":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"bcso":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"}},"personal":{"gender":"male","firstName":"Test","phone":"3435606634","position":{"name":"No Grades","level":0},"lastName":"Test"}}},"header":"Medical Services Boss Menu","icons":{"deny":"fa-regular fa-circle-xmark","employees":"fa-solid fa-users","approve":"fa-regular fa-circle-check","fire":"fa-solid fa-ban","applicants":"fa-solid fa-users-rectangle","promote":"fa-regular fa-thumbs-up","pastEmployee":"fa-solid fa-user-slash","deniedApplicants":"fa-solid fa-users-slash","pastEmployees":"fa-solid fa-users-slash","employee":"fa-solid fa-user","personal":"fa-solid fa-person-circle-exclamation","applicant":"fa-solid fa-user","close":"fa-solid fa-x","jobHistory":"fa-regular fa-address-card","retract":"fa-solid fa-angles-left","deniedApplicant":"fa-solid fa-user-slash","pay":"fa-solid fa-hand-holding-dollar","rapSheet":"fa-solid fa-handcuffs","demote":"fa-regular fa-thumbs-down"},"applicants":[],"jobsList":{"bus":"Bus Driver","taxi":"Taxi Driver","mechanic":"mechanic","lawyer":"Law Firm","garbage":"Sanitation Engineer","vineyard":"Vineyard","tow":"Tow Truck Operator","reporter":"News Reporter","realestate":"Real Estate","unemployed":"Civilian","cardealer":"Vehicle Dealer","ambulance":"Medical Services","police":"Law Enforcement","hotdog":"Hotdog Vendor","trucker":"Truck Driver","judge":"judge","bcso":"Blaine County Sheriff's Office"},"currentJob":"ambulance","currentJobName":"Medical Services","status":{"pending":"Pending","hired":"Hired","blacklisted":"Black Listed","fired":"Fired","quit":"Quit"},"deniedApplicants":{"HQQ55159":{"rapSheet":[],"jobHistory":{"bus":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"taxi":{"firedcount":0,"denycount":0,"hiredcount":1,"awards":[],"details":["was hired by taxi"],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"hired"},"mechanic":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"lawyer":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"garbage":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"vineyard":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"unemployed":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"cardealer":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"trucker":{"firedcount":0,"denycount":0,"hiredcount":1,"awards":[],"details":["was hired by trucker"],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"hired"},"reporter":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"realestate":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"ambulance":{"firedcount":0,"denycount":1,"hiredcount":0,"awards":[],"details":["Application was Denied"],"rehireable":true,"applycount":1,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"denied"},"police":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"hotdog":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"tow":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"judge":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"bcso":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"}},"personal":{"gender":"male","firstName":"mot","phone":"1592797008","lastName":"mot"}},"TMY15734":{"rapSheet":[],"jobHistory":{"bus":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"taxi":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"mechanic":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"lawyer":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"garbage":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"vineyard":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"unemployed":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"cardealer":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"trucker":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"reporter":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"realestate":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"ambulance":{"firedcount":0,"denycount":8,"hiredcount":0,"awards":[],"details":["Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied"],"rehireable":true,"applycount":9,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"denied"},"police":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"judge":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"hotdog":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"tow":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"bcso":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"}},"personal":{"gender":"male","firstName":"foook","phone":"2684675351","lastName":"noot"}},"ATE85065":{"rapSheet":[],"jobHistory":{"bus":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"taxi":{"firedcount":0,"denycount":0,"hiredcount":2,"awards":[],"details":["was hired by taxi","was hired by taxi"],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"hired"},"mechanic":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"lawyer":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"garbage":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"vineyard":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"unemployed":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"cardealer":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"trucker":{"firedcount":0,"denycount":0,"hiredcount":3,"awards":[],"details":["was hired by trucker","was hired by trucker","was hired by trucker"],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"hired"},"reporter":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"realestate":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"ambulance":{"firedcount":0,"denycount":1,"hiredcount":0,"awards":[],"details":["Application was Denied"],"rehireable":true,"applycount":1,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"denied"},"police":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"hotdog":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"tow":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"judge":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"bcso":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"}},"personal":{"gender":"male","firstName":"John","phone":"7342854485","lastName":"Doe"}},"MTQ14036":{"rapSheet":[],"jobHistory":{"bus":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"taxi":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"mechanic":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"lawyer":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"garbage":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"vineyard":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"unemployed":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"cardealer":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"trucker":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"reporter":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"realestate":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"ambulance":{"firedcount":0,"denycount":2,"hiredcount":0,"awards":[],"details":["Application was Denied","Application was Denied"],"rehireable":true,"applycount":2,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"denied"},"police":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"judge":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"hotdog":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"tow":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"bcso":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"}},"personal":{"gender":"male","firstName":"Little","phone":"6197775419","lastName":"Rager"}},"CFO10134":{"rapSheet":[],"jobHistory":{"bus":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"taxi":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"mechanic":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"lawyer":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"garbage":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"vineyard":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"unemployed":{"firedcount":0,"denycount":0,"hiredcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"available"},"cardealer":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"trucker":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"reporter":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"realestate":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"ambulance":{"firedcount":0,"denycount":1,"hiredcount":0,"awards":[],"details":["Application was Denied"],"rehireable":true,"applycount":2,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"denied"},"police":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"hotdog":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"tow":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"judge":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"},"bcso":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"grades":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"reprimands":[],"hiredcount":0,"status":"available"}},"personal":{"gender":"male","firstName":"Abdullah ","phone":"6069108880","lastName":"Ali"}},"YMG63813":{"rapSheet":[],"jobHistory":{"bus":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"taxi":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"mechanic":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"lawyer":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"garbage":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"vineyard":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"unemployed":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"cardealer":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"trucker":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"reporter":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"realestate":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"ambulance":{"firedcount":0,"denycount":1,"hiredcount":0,"awards":[],"details":["Application was Denied"],"rehireable":true,"applycount":1,"gradechangecount":0,"reprimands":[],"quitcount":0,"status":"denied"},"police":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"hotdog":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"tow":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"judge":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"},"bcso":{"firedcount":0,"denycount":0,"quitcount":0,"awards":[],"details":[],"rehireable":true,"applycount":0,"gradechangecount":0,"hiredcount":0,"reprimands":[],"status":"available"}},"personal":{"gender":"male","firstName":"Robert","phone":"7663043589","lastName":"Crews"}}},"awards":[{"title":"Award of Excellence","description":"Awarded for going above and beyond service to patients."},{"title":"Honorable Action","description":"Awarded for saving a life with risk to life and limb. While on duty or off duty."},{"title":"Meritous Action","description":"Awarded for saving a life while off duty. Not looking away when others could be of service."},{"title":"Medical Heart Award","description":"Awarded for being wounded on the mean streets of San Andreas."}]}
/*** Filtered jobHistory ***/
/* btnList = {"currentJobName":"Medical Services","awards":[{"description":"Awarded for going above and beyond service to patients.","title":"Award of Excellence"},{"description":"Awarded for saving a life with risk to life and limb. While on duty or off duty.","title":"Honorable Action"},{"description":"Awarded for saving a life while off duty. Not looking away when others could be of service.","title":"Meritous Action"},{"description":"Awarded for being wounded on the mean streets of San Andreas.","title":"Medical Heart Award"}],"header":"Medical Services Boss Menu","applicants":{"MTQ14036":{"personal":{"phone":"6197775419","lastName":"Rager","gender":"male","firstName":"Little"},"rapSheet":[],"jobHistory":{"ambulance":{"quitcount":0,"firedcount":0,"awards":[],"rehireable":true,"denycount":13,"details":["Application was Denied","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin"],"reprimands":[],"gradechangecount":0,"hiredcount":0,"applycount":14,"status":"pending"}}},"CFO10134":{"personal":{"phone":"6069108880","lastName":"Ali","gender":"male","firstName":"Abdullah "},"rapSheet":[],"jobHistory":{"ambulance":{"quitcount":0,"firedcount":0,"awards":[],"rehireable":true,"denycount":14,"details":["Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin"],"reprimands":[],"gradechangecount":0,"hiredcount":0,"applycount":16,"status":"pending"}}},"TMY15734":{"personal":{"phone":"2684675351","lastName":"noot","gender":"male","firstName":"foook"},"rapSheet":[],"jobHistory":{"ambulance":{"quitcount":0,"firedcount":0,"awards":[],"rehireable":true,"denycount":19,"details":["Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin"],"reprimands":[],"gradechangecount":0,"hiredcount":0,"applycount":21,"status":"pending"}}},"YMG63813":{"personal":{"phone":"7663043589","lastName":"Crews","gender":"male","firstName":"Robert"},"rapSheet":[],"jobHistory":{"ambulance":{"quitcount":0,"firedcount":0,"awards":[],"rehireable":true,"denycount":8,"details":["Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin"],"reprimands":[],"gradechangecount":0,"hiredcount":0,"applycount":9,"status":"pending"}}},"ATE85065":{"personal":{"phone":"7342854485","lastName":"Doe","gender":"male","firstName":"John"},"rapSheet":[],"jobHistory":{"trucker":{"quitcount":0,"firedcount":0,"awards":[],"rehireable":true,"denycount":0,"details":["was hired by trucker","was hired by trucker","was hired by trucker"],"reprimands":[],"gradechangecount":0,"hiredcount":3,"applycount":0,"status":"hired"},"ambulance":{"quitcount":0,"firedcount":0,"awards":[],"rehireable":true,"denycount":21,"details":["Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin"],"reprimands":[],"gradechangecount":0,"hiredcount":0,"applycount":22,"status":"pending"},"taxi":{"quitcount":0,"firedcount":0,"awards":[],"rehireable":true,"denycount":0,"details":["was hired by taxi","was hired by taxi"],"reprimands":[],"gradechangecount":0,"hiredcount":2,"applycount":0,"status":"hired"}}}},"deniedApplicants":{"HQQ55159":{"personal":{"phone":"1592797008","lastName":"mot","gender":"male","firstName":"mot"},"rapSheet":[],"jobHistory":{"trucker":{"quitcount":0,"firedcount":0,"awards":[],"rehireable":true,"denycount":0,"details":["was hired by trucker"],"reprimands":[],"gradechangecount":0,"hiredcount":1,"applycount":0,"status":"hired"},"ambulance":{"quitcount":0,"firedcount":0,"awards":[],"rehireable":true,"denycount":12,"details":["Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied","Application ReSubmitted by Admin","Application was Denied"],"reprimands":[],"gradechangecount":0,"hiredcount":0,"applycount":12,"status":"denied"},"taxi":{"quitcount":0,"firedcount":0,"awards":[],"rehireable":true,"denycount":0,"details":["was hired by taxi"],"reprimands":[],"gradechangecount":0,"hiredcount":1,"applycount":0,"status":"hired"}}}},"employees":{"SPC88576":{"personal":{"firstName":"Test","lastName":"Test","gender":"male","position":{"level":0,"name":"No Grades"},"phone":"3435606634"},"rapSheet":[],"jobHistory":{"ambulance":{"quitcount":0,"firedcount":0,"awards":[],"rehireable":true,"denycount":0,"details":[],"reprimands":[],"gradechangecount":0,"hiredcount":2,"applycount":0,"status":"hired"}}}},"icons":{"fire":"fa-solid fa-ban","pastEmployee":"fa-solid fa-user-slash","applicant":"fa-solid fa-user","applicants":"fa-solid fa-users-rectangle","jobHistory":"fa-regular fa-address-card","pastEmployees":"fa-solid fa-users-slash","retract":"fa-solid fa-angles-left","deny":"fa-regular fa-circle-xmark","approve":"fa-regular fa-circle-check","deniedApplicant":"fa-solid fa-user-slash","deniedApplicants":"fa-solid fa-users-slash","close":"fa-solid fa-x","rapSheet":"fa-solid fa-handcuffs","promote":"fa-regular fa-thumbs-up","employee":"fa-solid fa-user","personal":"fa-solid fa-person-circle-exclamation","employees":"fa-solid fa-users","demote":"fa-regular fa-thumbs-down","pay":"fa-solid fa-hand-holding-dollar"},"jobsList":{"bcso":"Blaine County Sheriff's Office","judge":"judge","realestate":"Real Estate","lawyer":"Law Firm","unemployed":"Civilian","garbage":"Sanitation Engineer","reporter":"News Reporter","bus":"Bus Driver","mechanic":"mechanic","trucker":"Truck Driver","police":"Law Enforcement","hotdog":"Hotdog Vendor","tow":"Tow Truck Operator","ambulance":"Medical Services","taxi":"Taxi Driver","vineyard":"Vineyard","cardealer":"Vehicle Dealer"},"pastEmployees":[],"currentJob":"ambulance","reprimands":[{"description":"Making a mistake while treating a patient","title":"Malpractice"},{"description":"Failure to follow directions.","title":"Insubordination"},{"description":"Failure to follow safety guidelines.","title":"Unsafe Behavior"},{"description":"Fails to call out & fails to show up.","title":"No Call / No Show"},{"description":"Any reason that necessitates a write up.","title":"Other"}],"status":{"quit":"Quit","fired":"Fired","blacklisted":"Black Listed","hired":"Hired","pending":"Pending"}}
/* Navigation */
const open = () => {
    resetMenus();
    processMainMenu();
    resetMenus();
    $("#container").fadeIn(150, () => {
        $("#mainMenuContainer").fadeIn(0, () => {
            $("#mainMenuHeader").fadeIn(0);
            $("#mainMenuContent").fadeIn(0);
        });
    });
}
const close = () => {let data = null
    $("#contentContainer").removeClass("open");
    $("#subMenuContainer").removeClass("open");
    $("#container").fadeOut(150, () => {
        resetMenus();
        empty();
    });
    $.post('https://qb-jobs/closeMenu', data, function(){})
}
const emptyMainMenu = () => {
    $("#mainMenuHeaderH1").empty();
    $("#mainMenuCloseContainer").empty();
    $("#mainMenuActionButtons").empty();
    $("#mainMenuContent").empty();
}
const emptySubMenu = () => {
    $("#subMenuHeaderH1").empty();
    $("#subMenuRetractContainer").empty();
    $("#subMenuActionButtons").empty();
    $("#subMenuContent").empty();
}
const emptyContent = () => {
    $("#contentHeaderH1").empty();
    $("#contentRetractContainer").empty();
    $("#contentActionButtons").empty();
    $("#content").empty();
}
const empty = () => {
    emptyMainMenu();
    emptySubMenu();
    emptyContent();
}
const resetMenus = () => {
    $("#mainMenuContainer").fadeOut();
    $("#mainMenuHeader").hide();
    $("#mainMenuContent").hide();
/*    $("#subMenuContainer").hide();
    $("#subMenuHeader").hide();
    $("#subMenuContent").hide();  */
    for(let i = 0; i <= btnCnt; i++){
        $(`#nav${i}`).hide();
        $(`#navSub${i}`).hide();
    }
}
const chooseNavDirection = (effect,btnid,element,target,targetID) => {
    closeSlideOuts(btnid)
    switch (effect) {
        case "upDown":
            menuRoutes(element,target)
        break;
        case "leftRight":
            tractMenuWindow(element,target,targetID)
        break
    }
}
const closeSlideOuts = (btnid) => {
    if(btnid == "mainMenuNavButton"){
        $("#contentContainer").removeAttr("class");
        $("#subMenuContainer").removeAttr("class");
    }
    if(btnid == "mainMenuNavSubButton"){
        $("#contentContainer").removeAttr("class");
    }
}
const traction = (element) => {
    if (element == "#subMenuContainer") {
        emptySubMenu();
        emptyContent();
        $("#contentContainer").removeAttr("class");
    }else{emptyContent();}
    $(element).removeAttr("class");
}
const tractMenuWindow = (element,target,targetID) => {
    const clearClass = () => {
        for (i = 0; i <= btnCnt; i++) {
            $(element).removeClass(`${target}${i}`);
        }
    }
    if($(element).hasClass("open") && $(element).hasClass(`${target}${targetID}`)) {
        clearClass();
        traction(element);
    }else{
        clearClass()
        $(element).addClass(`open ${target}${targetID}`);
    }
}
const menuRoutes = (element,target) => {
    if($(element).hasClass(target)) {
        $(`.${target}`).removeClass(target);
    }else{
        $(`.${target}`).slideUp();
        $(`.${target}`).removeClass(target);
    }
    $(element).toggle(target);
    $(element).addClass(target);
}
const uiManipulator = () => {
    for (const [_,v] of Object.entries(btnList.uiColors)) {
        $('head').append("<style>"+v.element+"{"+v.property+":"+v.value+";}</style>");
    }
}
const processMainMenu = () => {
    let mainMenuNavButtons = "";
    let MainMenuActionButtons = "";
    mainMenuNavButtons += `<div class="mainMenuNavButtons">`;
    let title = null;
    switch(action) {
        case "garage":
            if (btnList.ownedVehicles) {
                mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.ownGarage}"></i>My Garage</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
                for (const [key] of Object.entries(btnList.ownedVehicles)) {
                    mainMenuNavButtons += `<div class="mainMenuSubButtonItem"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-selgar="ownGarage" data-vehtype="${key}" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons[key]}"></i>${key}</button></div>`;
                    btnCnt++
                };
                mainMenuNavButtons += "</div></div>";
                btnCnt++;
            }
            mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.jobGarage}"></i>Motorpool</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
            for (const [key] of Object.entries(btnList.vehicles)) {
                mainMenuNavButtons += `<div class="mainMenuSubButtonItem"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-selgar="motorpool" data-vehtype="${key}" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons[key]}"></i>${key}</button></div>`;
                btnCnt++
            };
            mainMenuNavButtons += `</div></div>`;
            btnCnt++;
            if (btnList.allowPurchase) {
                mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.jobStore}"></i>Vehicle Shop</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons"></button></div>`;
                for (const [key] of Object.entries(btnList.vehiclesForSale)) {
                    mainMenuNavButtons += `<div class="mainMenuSubButtonItem"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-selgar="jobStore" data-vehtype="${key}" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons[key]}"></i>${key}</button></div>`;
                    btnCnt++
                };
                mainMenuNavButtons += "</div></div>";
                btnCnt++;
            }
            if(!jQuery.isEmptyObject(btnList.returnVehicle)){
                mainMenuNavButtons += `<div class="mainMenuNavButtons"><div class="mainMenuButtonItem" id="btnReturnVehicle"><button class="TempMain actionButton" data-btnid="mainMenuNavButton" data-id="nav${btnCnt}" data-vehtype="returnVehicle" data-selgar="returnVehicle" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons.returnVehicle}"></i>Return Vehicles</button></div></div>`;
                btnCnt++
                btnCnt++;
            }
        break;
        case "management":
            if (!jQuery.isEmptyObject(btnList.applicants)) {
                mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.applicants}"></i>Applicants</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
                for (const [key] of Object.entries(btnList.applicants)) {
                    mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem" id="${key}"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-type="applicants" data-citid="${key}" data-action="bossSubMenu" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons.applicant}"></i>${btnList.applicants[key].personal.firstName} ${btnList.applicants[key].personal.lastName}</button></div>`;
                    btnCnt++
                };
                mainMenuNavButtons += "</div></div>";
                btnCnt++;
            }
            if (!jQuery.isEmptyObject(btnList.employees)) {
                mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.employees}"></i>Employees</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
                for (const [key] of Object.entries(btnList.employees)) {
                    if (typeof btnList.employees[key].personal.position !== "undefined"){title = `<br /> ${btnList.employees[key].personal.position.name}`}
                    mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem" id="${key}"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavButton" data-type="employees" data-citid="${key}" data-action="bossSubMenu" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons.employee}"></i>${btnList.employees[key].personal.firstName} ${btnList.employees[key].personal.lastName}${title}</button></div>`;
                    btnCnt++
                };
                mainMenuNavButtons += "</div></div>";
                btnCnt++;
            }
            if (!jQuery.isEmptyObject(btnList.pastEmployees)) {
                mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.employees}"></i>Employees</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
                for (const [key] of Object.entries(btnList.pastEmployees)) {
                    mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem" id="${key}"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-type="pastEmployees" data-citid="${key}" data-action="bossSubMenu" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons.employee}"></i>${btnList.pastEmployees[key].personal.firstName} ${btnList.pastEmployees[key].personal.lastName}</button></div>`;
                    btnCnt++
                };
                mainMenuNavButtons += "</div></div>";
                btnCnt++;
            }
            if (!jQuery.isEmptyObject(btnList.deniedApplicants)) {
                mainMenuNavButtons += `<div class="mainMenuNavButtonItem"><button class="mainMenuNavButton actionButton" data-btnid="mainMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempMain" data-effect="upDown" data-element="#nav${btnCnt}"><i class="${btnList.icons.deniedApplicants}"></i>Denied Applicants</button><div id="nav${btnCnt}" class="mainMenuNavSubButtons">`;
                for (const [key] of Object.entries(btnList.deniedApplicants)) {
                    mainMenuNavButtons += `<div class="mainMenuNavSubButtonItem" id="${key}"><button class="mainMenuNavSubButton actionButton" data-btnid="mainMenuNavSubButton" data-type="deniedApplicants" data-citid="${key}" data-action="bossSubMenu" data-effect="leftRight" data-element="#subMenuContainer" data-target="sub" data-targetid="${btnCnt}"><i class="${btnList.icons.deniedApplicant}"></i>${btnList.deniedApplicants[key].personal.firstName} ${btnList.deniedApplicants[key].personal.lastName}</button></div>`;
                    btnCnt++
                };
                mainMenuNavButtons += "</div></div>";
                btnCnt++;
            }
        break;
    }
    mainMenuNavButtons += `</div>`;
    emptyMainMenu();
    appendMainMenuHeader();
    $("#mainMenuContent").append(mainMenuNavButtons);
}
const processSubMenu = (data) => {
    let subMenuNavButtons = "";
    let subMenuNavSubButtons = "";
    let subMenuActionButtons = "";
    let btn = "";
    let element = "";
    let vehicles = [];
    switch(action) {
        case "garage":
            switch(data.selGar) {
                case "ownGarage":
                    vehicles = btnList.ownedVehicles;
                    data.header = `My Garage`;
                break;
                case "jobStore":
                    vehicles = btnList.vehiclesForSale;
                    data.header = `Vehicle Shop`;
                break;
                case "motorpool":
                    vehicles = btnList.vehicles;
                    data.header = `Motorpool`;
                break;
                case "returnVehicle":
                    vehicles["returnVehicle"] = [];
                    vehicles.returnVehicle = btnList.returnVehicle;
                    data.header = "Return Vehicle";
                break;
            }
            subMenuNavButtons += `<div class="subMenuNavButtons">`;
            for (const [key,value] of Object.entries(vehicles[data.vehType])) {
                if (data.selGar == "returnVehicle") {
                    subMenuNavButtons += `<div class="subMenuNavButtonItem"><button id="${key}" class="subMenuNavButton" data-btnid="subMenuNavButton" data-plate="${key}"><i class="${btnList.icons.returnVehicle}"></i>${value.vehicle}<br />${key}</button></div>`;
                } else if (data.selGar == "ownGarage") {
                    let btnhide = "";
                    if(btnList.returnVehicle[value.plate]){
                        btnhide = `style="display:none;"`;
                    }
                    if(value.parkingPrice){element = `<br />${value.plate}<br /><u><strong>Parking Fee</strong></u><br />$${value.parkingPrice}`}
                    subMenuNavButtons += `<div class="subMenuNavButtonItem" id="btn${value.plate}" ${btnhide}><button id="${value.plate}" class="subMenuNavButton" data-btnid="subMenuNavButton" data-plate="${value.plate}" data-selgar="${data.selGar}" data-vehicle="${value.spawn}"><i class="${value.icon}"></i>${value.label}${element}</button></div>`;
                } else {
                    if (data.selGar == "jobStore") {
                        if(value.purchasePrice){element = `<br /><u><strong>Purchase Price</strong></u><br />$${value.purchasePrice}`}
                    }
                    else if (data.selGar == "motorpool") {
                        element = "";
                        if(value.depositPrice){element += `<br /><u><strong>Refundable Deposit</strong></u><br />$${value.depositPrice}`}
                        if(value.rentPrice){element += `<br /><u><strong>Rental Price</strong></u><br />$${value.rentPrice}`}
                    }
                    subMenuNavButtons += `<div class="subMenuNavButtonItem"><li><button id="${key}" class="subMenuNavButton" data-btnid="subMenuNavButton" data-selgar="${data.selGar}" data-vehicle="${value.spawn}"><i class="${value.icon}"></i>${value.label}${value.element}</button></div>`;
                }
            };
            subMenuNavButtons += "</div>"
        break;
        case "management":
            const jobHistory = btnList[data.type][data.citid].jobHistory;
            const personal = btnList[data.type][data.citid].personal
            if(!jobHistory[btnList.currentJob].rehireable){subMenuNavButtons += `<h3 class="blackListed">-- DO NOT HIRE --<br />Black Listed</h3>`;}
            data.header = `${personal.firstName} ${btnList[data.type][data.citid].personal.lastName}`;
            switch(data.type){
                case "applicants":
                    subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-effect="leftRight" data-element="#subMenuContainer" data-baction="approve"><i class="${btnList.icons.approve}"></i>Approve</button></div>`;
                    subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-effect="leftRight" data-element="#subMenuContainer" data-baction="deny"><i class="${btnList.icons.deny}"></i>Deny</button></div>`;
                break;
                case "employees":
                    subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-effect="leftRight" data-element="#subMenuContainer" data-baction="promote"><i class="${btnList.icons.promote}"></i>Promote</button></div>`;
                    subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-effect="leftRight" data-element="#subMenuContainer" data-baction="demote"><i class="${btnList.icons.demote}"></i>Demote</button></div>`;
                    subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-effect="leftRight" data-element="#subMenuContainer" data-baction="pay"><i class="${btnList.icons.pay}"></i>Adjust Pay</button></div>`;
                    subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}" data-action="bossAction" data-effect="leftRight" data-element="#subMenuContainer" data-baction="terminate"><i class="${btnList.icons.fire}"></i>Terminate</button></div>`;
                break;
                case "pastEmployees":
                    // added this for future mainMenuContent (maybe)
                break;
                case "deniedApplicants":
                    subMenuActionButtons += `<div class="subMenuActionButtonItem"><button class="subMenuActionButton actionButton" data-appcid="${data.citid}"  data-action="bossAction" data-effect="leftRight" data-element="#subMenuContainer" data-baction="apply"><i class="${btnList.icons.deny}"></i>Reconsider</button></div>`;
                break;
            }
            subMenuNavButtons = `<div class="subMenuNavButtons">`
            btnCnt++;
            subMenuNavButtons += `<div class="subMenuNavButtonItem"><button class="subMenuNavButton actionButton" data-btnid="subMenuNavButton" data-job="${btnList.currentJob}" data-ctype="personal" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons.personal}"></i>Personal Details</button></div>`;
            btnCnt++
            subMenuNavButtons += `<div class="subMenuNavButtonItem"><button class="subMenuNavButton actionButton" data-btnid="subMenuNavButton" data-job="${btnList.currentJob}" data-ctype="rapSheet" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons.rapSheet}"></i>Rap Sheet</button></div>`;
            btnCnt++
            subMenuNavButtons += `<div class="subMenuNavButtonItem"><button class="subMenuNavButton actionButton" data-btnid="subMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempSub" data-effect="upDown" data-element="#navSub${btnCnt}" data-id="${btnCnt}"><i class="${btnList.icons.currentJob}"></i>${btnList.currentJobName} Record</button><div id="navSub${btnCnt}" class="subMenuNavSubButtons">`;
            btnCnt++;
            subMenuNavButtons += `<div class="subMenuNavSubButtonItem"><button class="subMenuNavSubButton actionButton" actionButton" data-btnid="subMenuNavSubButton" data-job="${btnList.currentJob}" data-ctype="history" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons.currentJob}"></i>Stats</button></div>`;
            btnCnt++;
            subMenuNavButtons += `<div class="subMenuNavSubButtonItem"><button class="subMenuNavSubButton actionButton" actionButton" data-btnid="subMenuNavSubButton" data-job="${btnList.currentJob}" data-ctype="awards" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons.currentJob}"></i>Awards</button></div>`;
            btnCnt++;
            subMenuNavButtons += `<div class="subMenuNavSubButtonItem"><button class="subMenuNavSubButton actionButton" actionButton" data-btnid="subMenuNavSubButton" data-job="${btnList.currentJob}" data-ctype="reprimands" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons.currentJob}"></i>Reprimands</button></div>`;
            btnCnt++;
            subMenuNavButtons += `<div class="subMenuNavSubButtonItem"><button class="subMenuNavSubButton actionButton" actionButton" data-job="${btnList.currentJob}" data-ctype="notes" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-btnid="subMenuNavSubButton" data-targetid="${btnCnt}"><i class="${btnList.icons.currentJob}"></i>Notes</button></div>`;
            btnCnt++;
            subMenuNavButtons += `</div></div>`;
            subMenuNavButtons += `<div class="subMenuNavButtonItem"><button class="subMenuNavButton actionButton" data-btnid="subMenuNavButton" data-action="navButton" data-targetID="empty" data-target="TempSub" data-effect="upDown" data-element="#navSub${btnCnt}" data-id="${btnCnt}"><i class="${btnList.icons.jobHistory}"></i>Job History</button><div id="navSub${btnCnt}" class="subMenuNavSubButtons">`;
            btnCnt++;
            if(!$.isEmptyObject(jobHistory)) {
                $.each(jobHistory, function(k,v){
                    if(k != btnList.currentJob) {
                        btn += `<div class="subMenuNavSubButtonItem"><button class="subMenuNavSubButton actionButton" data-btnid="subMenuNavSubButton" data-job="${k}" data-ctype="history" data-type="${data.type}" data-citid="${data.citid}" data-action="bossContent" data-effect="leftRight" data-element="#contentContainer" data-target="con" data-targetid="${btnCnt}"><i class="${btnList.icons.jobHistory}"></i>${k} Stats<br />${v.status}</button></div>`;
                        btnCnt++;
                    }
                })
            }
            if(btn == ""){btn = `<div class="subMenuNavSubButtonItem"><button class="subMenuNavSubButton" data-btnid="subMenuNavSubButton">No Job History</button></div>`;}
            btnCnt++;
            subMenuNavButtons += `${btn}</div></div>`;
        break;
    }
    emptySubMenu();
    $("#subMenuHeaderH1").append(data.header);
    $("#subMenuRetractContainer").append(`<button class="subMenuRetractButton actionButton" data-action="retract" data-element="#subMenuContainer"><i class="${btnList.icons.retract}"></i></button>`)
    $("#subMenuActionButtons").append(subMenuActionButtons);
    $("#subMenuContent").append(subMenuNavButtons);
}
const processContent = (data) => {
    let content = "";
    let contentHeader = "";
    const personal = btnList[data.type][data.citid].personal
    const rapSheet = btnList[data.type][data.citid].rapSheet
    const jobHistory = btnList[data.type][data.citid].jobHistory[data.job]
    const awards = jobHistory.awards
    const reprimands = jobHistory.reprimands
    const details = jobHistory.details
    const jobName = btnList.jobsList[data.job]
    let status = {
        hired: [],
        fired: [],
        quit: [],
        blackListed: []
    };
    switch(data.ctype) {
        case "history":
            contentHeader = `${jobName}`;
            content = `<table class="stats"><caption>Stats</caption>`
            content += `<tr><th>Applied</th><th>Hired</th><th>Denied</th></tr>`;
            content += `<tr><td>${jobHistory.applycount}</td><td>${jobHistory.hiredcount}</td><td>${jobHistory.denycount}</td></tr>`
            content += `<tr><th>Quit</th><th>Fired</th><th>Grades</th></tr>`
            content += `<tr><td>${jobHistory.quitcount}</td><td>${jobHistory.firedcount}</td><td>${jobHistory.gradechangecount}</td></tr>`;
            content += `</table>`;
        break;
        case "personal":
            contentHeader = `Personal Information`;
            content = `<div class="contentBody"><table class="deets"><tr><th>First Name</th><td>${personal["firstName"]}</td></tr>`;
            content += `<tr><th>Last Name</th><td>${personal["lastName"]}</td></tr>`;
            content += `<tr><th>Phone Number</th><td>${personal["phone"]}</td></tr>`;
            content += `<tr><th>Gender</th><td>${personal["gender"]}</td></tr></table></div>`;
        break;
        case "rapSheet":
            contentHeader = `Criminal Record`;
            content = `<div class="contentBody"><table class="deets">`;
            if(!$.isEmptyObject(rapSheet)) {
                $.each(rapSheet, function(k,v){
                    content += `<tr><th>${k}</th><td>${v}</td></tr>`;
                })
            }else{content += `<tr><td class="contentListItem">No Criminal Record</td></tr>`}
            content += `</table></div>`;
        break;
        case "awards":
            contentHeader = `Awards`;
            content = `<div class="contentBody"><table class="deets">`;
            if(!$.isEmptyObject(awards)) {
                $.each(awards, function(k,v){
                    content += `<tr><th>${k}</th><td>${v}</td></tr>`;
                })
            }else{content += `<tr><td>No Awards Received</td></tr>`}
            content += `</table></div>`;
        break;
        case "reprimands":
            contentHeader = `Reprimands`;
            content = `<div class="contentBody"><table class="deets">`;
            if(!$.isEmptyObject(reprimands)) {
                $.each(reprimands, function(k,v){
                    content += `<tr><th>${k}</th><td>${v}</td></tr>`;
                })
            }else{content += `<tr><td>No Reprimands Received</td></tr>`}
            content += `</table></div>`;
        break;
        case "notes":
            contentHeader = `Notes`;
            content = `<div class="contentBody"><table class="deets">`;
            if(!$.isEmptyObject(details)) {
                $.each(details, function(k,v){
                    content += `<tr><th>${k}</th><td>${v}</td></tr>`;
                })
            }else{content += `<tr><td>No Details to Display</td></tr>`}
            content += `</table></div>`;
        break;
    }
    emptyContent();
    $("#contentHeaderH1").append(contentHeader);
    $("#contentRetractContainer").append(`<button class="contentRetractButton actionButton" data-action="retract" data-element="#contentContainer"><i class="${btnList.icons.retract}"></i></button>`)
    $("#contentActionButtons").append(contentActionButtons);
    $("#content").append(content);
}
const appendMainMenuHeader = () => {
    $("#mainMenuHeaderH1").append(btnList.header);
    $("#mainMenuCloseContainer").append(`<button id="closeButton" class="actionButton"  data-action="close"><i class="${btnList.icons.close}"></i></button>`)
}
const errorMessage = (error) => {
    v.msg += "<table>";
    $.each(error,(k,v) => {
        v.msg += `<tr><th>${k}</th><td>${v}</td>`
    });
    v.msg += "</table>";
    $(".alert").append(v.msg);
}
/* Main / Root Function */
$(document).ready(function(){
    window.addEventListener('message', function(event) {
        btnList = event.data.btnList;
        Lang = event.data.Lang;
        action = event.data.action;
        if(!$.isEmptyObject(btnList.uiColors)){uiManipulator();}
        appendMainMenuHeader()
        $(".draggable").draggable();
        open();
    })
/**  Development Testing Code **/
/*
    action = "management"
    appendMainMenuHeader();
    $(".draggable").draggable();
    open();
*/
});
/* Button Controls */
$(document).on('click', ".actionButton", function(e){
    e.preventDefault();
    let data;
    let btnid = $(this).data('btnid');
    let effect = $(this).data('effect');
    let target = $(this).data('target');
    let targetID = $(this).data('targetid');
    let element = $(this).data('element');
    switch ($(this).data("action")){
        case "bossAction":
            data = {
                appcid:$(this).data("appcid"),
                action:$(this).data("baction")
            }
            $.post('https://qb-jobs/managementSubMenuActions', JSON.stringify(data), function(res){
                switch(data.action){
                    case "deny":
                    break;
                    case "apply":
                    break;
                    case "approve":
                    break;
                    case "pay":
                    break;
                    case "promote":
                    break;
                    case "demote":
                    break;
                    case "terminate":
                    break;
                }
                traction("#subMenuContainer");
                delete btnList;
                btnList = res.btnList;
                action = "management";
                dbgmsg = "MGMTHere";
                empty();
                appendMainMenuHeader();
                processMainMenu();
            })
        break;
        case "bossSubMenu":
            data = {
                type:$(this).data("type"),
                job:$(this).data("job"),
                citid:$(this).data("citid")
            };
            processSubMenu(data);
        break;
        case "bossContent":
            data = {
                type:$(this).data("type"),
                citid:$(this).data("citid"),
                job:$(this).data("job"),
                ctype:$(this).data("ctype")
            };
            processContent(data);
        break;
        case "selVeh":
            data.garage = btnList.garage;
            data.vehicle = $(this).data('vehicle');
            data.selgar = $(this).data('selgar');
            if (data.garage === "ownGarage") {data.plate = $(this).data('plate');}
            $.post('https://qb-jobs/selectedVehicle', JSON.stringify(data))
            close();
        break
        case "listVeh":
            data = [];
            data.vehType = $(this).data('vehtype');
            data.selGar = $(this).data('selgar');
            emptySubMenu();
            processSubMenu(data);
        break;
        case "delVeh":
            if(btnList.returnVehicle[data.plate].selGar == "ownGarage") {
                $(`.btn${data.plate}`).show();
            }
            $.post('https://qb-jobs/delVeh', JSON.stringify(data.plate), function(result) {
                delete btnList.returnVehicle;
                btnList.returnVehicle = result;
                $(`#${data.plate}`).remove();
                if ($.isEmptyObject(btnList.returnVehicle)){
                    tractMenuWindow("#subMenuContainer",false,false);
                    tractMenuWindow("#contentMenuContainer",false,false);
                    $("#btnReturnVehicle").remove();
                }
            }, "json");
        break;
        case "navButton":
        break;
        case "retract":
            element = $(this).data('element');
            traction(element);
        break;
        case "close":
            close();
        break;
    }
    if(effect != "undefined"){
        chooseNavDirection(effect,btnid,element,target,targetID)
    }
})
$(document).on('keyup', function(e) {
    if(e.key == "Escape"){ close(); }
});