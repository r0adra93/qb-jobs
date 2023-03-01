/* Variables */
let btnList = [];
let btnCnt = 0;
let Lang = [];
let trick = 1;
let prevtrick = 0;
let active = ".active";
let id = "";
let action = "";
/* Variables for Development */
/** Garage **/
btnList = {"header":"Medical Services Vehicle Manager","icons":{"helicopter":"fa-solid fa-helicopter","vehicle":"fa-solid fa-truck-medical","retract":"fa-solid fa-angles-left","plane":"fa-solid fa-plane","close":"fa-regular fa-circle-xmark","boat":"fa-solid fa-ship","ownGarage":"fa-solid fa-warehouse","jobGarage":"fa-solid fa-square-parking","returnVehicle":"fa-solid fa-rotate-left","jobStore":"fa-solid fa-store"},"ownedVehicles":{"helicopter":{"0":{"icon":"fa-solid fa-helicopter","plate":"EMS54321","parkingPrice":125,"label":"Maverick","purchasePrice":1000,"spawn":"polmav"}},"vehicle":{"0":{"icon":"fa-solid fa-truck-medical","plate":"EMS12345","parkingPrice":125,"label":"Ambulance","purchasePrice":1000,"spawn":"ambulance"}}},"allowPurchase":true,"vehicles":{"helicopter":[{"rentPrice":250,"parkingPrice":125,"icon":"fa-solid fa-helicopter","label":"Air Ambulance","purchasePrice":3000000,"spawn":"polmav"}],"vehicle":[{"rentPrice":250,"icon":"fa-solid fa-truck-medical","parkingPrice":125,"label":"Ambulance","depositPrice":250,"purchasePrice":150000,"spawn":"ambulance"}]},"vehiclesForSale":{"helicopter":[{"icon":"fa-solid fa-helicopter","parkingPrice":125,"purchasePrice":3000000,"label":"Air Ambulance","spawn":"polmav"}],"vehicle":[{"icon":"fa-solid fa-truck-medical","parkingPrice":125,"purchasePrice":150000,"label":"Ambulance","spawn":"ambulance"}]},"garage":1,"label":"Medical Services","returnVehicle":{"1370114":"ambulance","1369090":"ambulance","1364226":"ambulance","1364738":"ambulance","1366530":"ambulance","1365762":"ambulance","1363970":"ambulance"}};
btnList = btnList;
btnList.icons.retract = "fa-solid fa-angles-left";
/** Management **/
/* btnList = {"deniedApplicants":{"CFO10134":{"personal":{"lastName":"Ali","phone":"6069108880","firstName":"Abdullah "},"rapSheet":[],"jobHistory":{"lawyer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"cardealer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"unemployed":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"vineyard":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"judge":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"trucker":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"mechanic":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"bcso":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"realestate":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"taxi":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"bus":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"police":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"garbage":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"tow":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"hotdog":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"reporter":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"grades":[],"gradechangecount":0,"writeups":[],"hiredcount":0,"firedcount":0,"details":[],"status":"available","rehireable":true},"ambulance":{"denycount":1,"quitcount":0,"applycount":2,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"denied","details":["Application was Denied"],"writeups":[],"rehireable":true}}},"HQQ55159":{"personal":{"lastName":"mot","phone":"1592797008","firstName":"mot"},"rapSheet":[],"jobHistory":{"lawyer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"cardealer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"unemployed":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"vineyard":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"judge":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"trucker":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":1,"firedcount":0,"status":"hired","details":["was hired by trucker"],"writeups":[],"rehireable":true},"mechanic":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"bcso":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"realestate":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"taxi":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":1,"firedcount":0,"status":"hired","details":["was hired by taxi"],"writeups":[],"rehireable":true},"bus":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"police":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"garbage":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"tow":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"hotdog":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"reporter":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"ambulance":{"denycount":1,"quitcount":0,"applycount":1,"awards":[],"gradechangecount":0,"hiredcount":0,"writeups":[],"firedcount":0,"details":["Application was Denied"],"status":"denied","rehireable":true}}},"TMY15734":{"personal":{"lastName":"noot","phone":"2684675351","firstName":"foook"},"rapSheet":[],"jobHistory":{"lawyer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"cardealer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"unemployed":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"vineyard":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"judge":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"trucker":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"mechanic":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"bcso":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"realestate":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"taxi":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"bus":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"police":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"garbage":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"tow":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"hotdog":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"reporter":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"writeups":[],"gradechangecount":0,"hiredcount":0,"grades":[],"firedcount":0,"details":[],"status":"available","rehireable":true},"ambulance":{"denycount":8,"quitcount":0,"applycount":9,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"denied","details":["Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied"],"writeups":[],"rehireable":true}}},"ATE85065":{"personal":{"lastName":"Doe","phone":"7342854485","firstName":"John"},"rapSheet":[],"jobHistory":{"lawyer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"cardealer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"unemployed":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"vineyard":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"judge":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"trucker":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":3,"firedcount":0,"status":"hired","details":["was hired by trucker","was hired by trucker","was hired by trucker"],"writeups":[],"rehireable":true},"mechanic":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"bcso":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"realestate":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"taxi":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":2,"firedcount":0,"status":"hired","details":["was hired by taxi","was hired by taxi"],"writeups":[],"rehireable":true},"bus":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"police":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"garbage":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"tow":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"hotdog":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"reporter":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"ambulance":{"denycount":1,"quitcount":0,"applycount":1,"awards":[],"gradechangecount":0,"hiredcount":0,"writeups":[],"firedcount":0,"details":["Application was Denied"],"status":"denied","rehireable":true}}},"MTQ14036":{"personal":{"lastName":"Rager","phone":"6197775419","firstName":"Little"},"rapSheet":[],"jobHistory":{"lawyer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"cardealer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"unemployed":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"vineyard":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"judge":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"trucker":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"mechanic":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"bcso":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"realestate":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"taxi":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"bus":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"police":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"garbage":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"tow":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"hotdog":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"reporter":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"ambulance":{"denycount":2,"quitcount":0,"applycount":2,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"denied","details":["Application was Denied","Application was Denied"],"writeups":[],"rehireable":true}}},"YMG63813":{"personal":{"lastName":"Crews","phone":"7663043589","firstName":"Robert"},"rapSheet":[],"jobHistory":{"lawyer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"cardealer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"unemployed":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"vineyard":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"judge":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"trucker":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"mechanic":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"bcso":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"realestate":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"taxi":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"bus":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"police":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"garbage":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"tow":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"hotdog":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"reporter":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"ambulance":{"denycount":1,"quitcount":0,"applycount":1,"awards":[],"gradechangecount":0,"hiredcount":0,"writeups":[],"firedcount":0,"details":["Application was Denied"],"status":"denied","rehireable":true}}}},"applicants":[],"employees":{"SPC88576":{"personal":{"firstName":"Test","position":{"name":"No Grades","level":0},"phone":"3435606634","lastName":"Test"},"rapSheet":[],"jobHistory":{"lawyer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"cardealer":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"unemployed":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"vineyard":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"judge":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"trucker":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"mechanic":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"bcso":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"realestate":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"taxi":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"bus":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"police":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"garbage":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"tow":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"hotdog":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"reporter":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":0,"firedcount":0,"status":"available","details":[],"writeups":[],"rehireable":true},"ambulance":{"denycount":0,"quitcount":0,"applycount":0,"awards":[],"gradechangecount":0,"hiredcount":2,"firedcount":0,"status":"hired","details":[],"writeups":[],"rehireable":true}}}},"writeUps":[{"description":"Making a mistake while treating a patient","title":"Malpractice"},{"description":"Failure to follow directions.","title":"Insubordination"},{"description":"Failure to follow safety guidelines.","title":"Unsafe Behavior"},{"description":"Fails to call out & fails to show up.","title":"No Call / No Show"},{"description":"Any reason that necessitates a write up.","title":"Other"}],"header":"Medical Services Boss Menu","uiColors":[{"element":"h1","property":"background","value":"#DC143C"},{"element":"h1","property":"color","value":"#EFEFEF"},{"element":"h2","property":"background","value":"#DC143C"},{"element":"h2","property":"color","value":"#EFEFEF"},{"element":".navButton","property":"background","value":"#EFEFEF"},{"element":".navButton","property":"color","value":"#DC143C"},{"element":".navButton:hover","property":"background","value":"#DC143C"},{"element":".navButton:hover","property":"color","value":"#EFEFEF"},{"element":".navSubButton","property":"background","value":"#CFCFCF"},{"element":".navSubButton","property":"color","value":"#940C28"},{"element":".navSubButton:hover","property":"background","value":"#940C28"},{"element":".navSubButton:hover","property":"color","value":"#CFCFCF"},{"element":".pageButton","property":"background","value":"#EFEFEF"},{"element":".pageButton","property":"color","value":"#DC143C"},{"element":".pageButton:hover","property":"background","value":"#DC143C"},{"element":".pageButton:hover","property":"color","value":"#EFEFEF"},{"element":".pageButtonSub","property":"background","value":"#CFCFCF"},{"element":".pageButtonSub","property":"color","value":"#940C28"},{"element":".pageButtonSub:hover","property":"background","value":"#940C28"},{"element":".pageButtonSub:hover","property":"color","value":"#CFCFCF"},{"element":".cancel","property":"background","value":"#DC143C"},{"element":".cancel","property":"color","value":"#EFEFEF"},{"element":".cancel","property":"background","value":"#EFEFEF"},{"element":".cancel","property":"color","value":"#DC143C"},{"element":".retract","property":"background","value":"#DC143C"},{"element":".retract","property":"color","value":"#EFEFEF"},{"element":".cancel","property":"background","value":"#EFEFEF"},{"element":".cancel","property":"color","value":"#DC143C"}],"awards":[{"description":"Awarded for going above and beyond service to patients.","title":"Award of Excellence"},{"description":"Awarded for saving a life with risk to life and limb. While on duty or off duty.","title":"Honorable Action"},{"description":"Awarded for saving a life while off duty. Not looking away when others could be of service.","title":"Meritous Action"},{"description":"Awarded for being wounded on the mean streets of San Andreas.","title":"Medical Heart Award"}],"currentJob":"ambulance","status":{"blacklisted":"Black Listed","fired":"Fired","hired":"Hired","quit":"Quit","pending":"Pending"},"pastEmployees":[],"icons":{"employees":"fa-solid fa-users","deniedApplicant":"fa-solid fa-user-slash","demote":"fa-regular fa-thumbs-down","approve":"fa-regular fa-circle-check","personal":"fa-solid fa-person-circle-exclamation","pastEmployee":"fa-solid fa-user-slash","deniedApplicants":"fa-solid fa-users-slash","applicants":"fa-solid fa-users-rectangle","employee":"fa-solid fa-user","deny":"fa-regular fa-circle-xmark","pay":"fa-solid fa-hand-holding-dollar","promote":"fa-regular fa-thumbs-up","fire":"fa-solid fa-ban","rapSheet":"fa-solid fa-handcuffs","applicant":"fa-solid fa-user","pastEmployees":"fa-solid fa-users-slash","jobHistory":"fa-regular fa-address-card"}} */
/** Navigation **/
open = (action) => {
    resetMenus();
    mainMenu(action);
    resetMainMenu();
    $("#container").fadeIn(150, () => {
        $("#mainMenuContainer").fadeIn(150, () => {
            $("#mainMenuHeader").fadeIn(150);
            $("#mainMenuButtons").fadeIn(150);
        });
    });
}
close = () => {
    $("#subMenuContainer").fadeOut(150, () => {
        resetMenus();
        $("#container").fadeOut(150, () => {
            empty();
        });
    })
    $.post('https://qb-jobs/closeMenu')
}
extractSubMenu = () => {
    $("#subMenuContainer").animate({left:"35vh",opacity:"show",width:"show"},"slow","linear",function(){$(this).show()});
}
retractSubMenu = () => {
    $("#subMenuContainer").animate({opacity:"hide",width:"hide"},"slow","linear",function(){$(this).hide()});
}
empty = () => {
    $("#mainMenuHeader").empty();
    $("#mainMenuButtonsList").empty();
    $("#subMenuHeader").empty();
    $("#subMenuList").empty();
    $("#close").empty();
    $("#retract").empty();
}
resetMainMenu = () => {
    for(let i = 0; i <= btnCnt; i++){
        $(`#nav${i}-list`).hide();
        $(`#subMenuCard${i}`).hide();
    }
}
resetMenus = () => {
    $("#mainMenuContainer").hide();
    $("#mainMenuHeader").hide();
    $("#mainMenuButtons").hide();
    $("#subMenuContainer").hide();
    resetMainMenu();
}
menuRoutes = (step) => {
    if($(step).hasClass("tempClass")) {
        $(".tempClass").removeClass("tempClass");
    }else{
        $(".tempClass").slideUp();
        $(".tempClass").removeClass("tempClass");
    }
    $(step).slideToggle();
    $(step).addClass("tempClass");
}
subMenuRoutes = (step) => {
    if($(step).hasClass("tempSubClass")) {
        $(".tempSubClass").removeClass("tempSubClass");
    }else{
        $(".tempSubClass").slideUp();
        $(".tempSubClass").removeClass("tempSubClass");
    }
    $(step).slideToggle();
    $(step).addClass("tempSubClass");
}
uiManipulator = () => {
    for (const [_,v] of Object.entries(btnList.uiColors)) {
        $('head').append("<style>"+v.element+"{"+v.property+":"+v.value+";}</style>");
    }
}
mainMenu = () => {
    let builder = "";
    let title = null;
    switch(action) {
        case "garage":
            if (btnList.ownedVehicles) {
                builder += `<li><button class="navButton" data-id="nav${btnCnt}"><i class="${btnList.icons.ownGarage}"></i>My Garage</button><ul id="nav${btnCnt}-list">`;
                for (const [key] of Object.entries(btnList.ownedVehicles)) {
                    builder += `<li><button class="qb-jobs-vehicle-type navSubButton" data-selgar="ownGarage" data-vehtype="${key}"><i class="${btnList.icons[key]}"></i>${key}</li>`;
                };
                builder += "</ul></li>";
                btnCnt++;
            }
            builder += `<li><button class="navButton" data-id="nav${btnCnt}"><i class="${btnList.icons.jobGarage}"></i>Motorpool</button><ul id="nav${btnCnt}-list">`;
            for (const [key] of Object.entries(btnList.vehicles)) {
                builder += `<li><button class="qb-jobs-vehicle-type navSubButton" data-selgar="motorpool" data-vehtype="${key}"><i class="${btnList.icons[key]}"></i>${key}</li>`;
            };
            builder += `</ul></li>`;
            btnCnt++;
            if (btnList.allowPurchase) {
                builder += `<li><button class="navButton" data-id="nav${btnCnt}"><i class="${btnList.icons.jobStore}"></i>Vehicle Shop</button><ul id="nav${btnCnt}-list">`;
                for (const [key] of Object.entries(btnList.vehiclesForSale)) {
                    builder += `<li><button class="qb-jobs-vehicle-type navSubButton" data-selgar="jobStore" data-vehtype="${key}"><i class="${btnList.icons[key]}"></i>${key}</li>`;
                };
                builder += "</ul></li>";
                btnCnt++;
            }
            if(!jQuery.isEmptyObject(btnList.returnVehicle)){
                builder += `<li id="btnReturnVehicle"><button class="qb-jobs-vehicle-type navButton" data-id="nav${btnCnt}" data-vehtype="returnVehicle" data-selgar="returnVehicle"><i class="${btnList.icons.returnVehicle}"></i>Return Vehicles</button></li>`;
                btnCnt++;
            }
        break;
        case "management":
            if (!jQuery.isEmptyObject(btnList.applicants)) {
                builder += `<li><button class="navButton" data-id="nav${btnCnt}"><i class="${btnList.icons.applicants}"></i>Applicants</button><ul id="nav${btnCnt}-list">`;
                for (const [key] of Object.entries(btnList.applicants)) {
                    builder += `<li id="${key}"><button class="qb-jobs-management navSubButton" data-type="applicants" data-citid="${key}"><i class="${btnList.icons.applicant}"></i>${btnList.applicants[key].personal.firstName} ${btnList.applicants[key].personal.lastName}</li>`;
                };
                builder += "</ul></li>";
                btnCnt++;
            }
            if (!jQuery.isEmptyObject(btnList.employees)) {
                builder += `<li><button class="navButton" data-id="nav${btnCnt}"><i class="${btnList.icons.employees}"></i>Employees</button><ul id="nav${btnCnt}-list">`;
                for (const [key] of Object.entries(btnList.employees)) {
                    if (typeof btnList.employees[key].personal.position !== "undefined"){title = `<br /> ${btnList.employees[key].personal.position.name}`}
                    builder += `<li id="${key}"><button class="qb-jobs-management navSubButton" data-type="employees" data-citid="${key}"><i class="${btnList.icons.employee}"></i>${btnList.employees[key].personal.firstName} ${btnList.employees[key].personal.lastName}${title}</li>`;
                };
                builder += "</ul></li>";
                btnCnt++;
            }
            if (!jQuery.isEmptyObject(btnList.pastEmployees)) {
                builder += `<li><button class="navButton" data-id="nav${btnCnt}"><i class="${btnList.icons.employees}"></i>Employees</button><ul id="nav${btnCnt}-list">`;
                for (const [key] of Object.entries(btnList.pastEmployees)) {
                    builder += `<li id="${key}"><button class="qb-jobs-management navSubButton" data-type="pastEmployees" data-citid="${key}"><i class="${btnList.icons.employee}"></i>${btnList.pastEmployees[key].personal.firstName} ${btnList.pastEmployees[key].personal.lastName}</li>`;
                };
                builder += "</ul></li>";
                btnCnt++;
            }
            if (!jQuery.isEmptyObject(btnList.deniedApplicants)) {
                builder += `<li><button class="navButton" data-id="nav${btnCnt}"><i class="${btnList.icons.deniedApplicants}"></i>Denied Applicants</button><ul id="nav${btnCnt}-list">`;
                for (const [key] of Object.entries(btnList.deniedApplicants)) {
                    builder += `<li id="${key}"><button class="qb-jobs-management navSubButton" data-type="deniedApplicants" data-citid="${key}"><i class="${btnList.icons.deniedApplicant}"></i>${btnList.deniedApplicants[key].personal.firstName} ${btnList.deniedApplicants[key].personal.lastName}</li>`;
                };
                builder += "</ul></li>";
                btnCnt++;
            }
        break;
    }
    $("#mainMenuButtonsList").append(builder);
    $("#close").append(`<button id="close-button" class="close"><i class="${btnList.icons.close}"></i>Close</button>`)
    $("#retract").append(`<button id="retract-button" class="retract"><i class="${btnList.icons.retract}"></i>Retract</button>`)
}
subMenu = (data) => {
    let vehicles = [];
    let builder = "";
    let b1 = "";
    let status = {
        hired: [],
        fired: [],
        quit: [],
        blackListed: []
    };
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
            for (const [key,value] of Object.entries(vehicles[data.vehType])) {
                if (data.selGar == "returnVehicle") {
                    builder += `<li><button id="${key}" class="qb-jobs-vehicle-return pageButton" data-plate="${key}"><i class="${btnList.icons.returnVehicle}"></i>${value.vehicle}<br />${key}`;
                } else if (data.selGar == "ownGarage") {
                    let btnhide = "";
                    if(btnList.returnVehicle[value.plate]){
                        btnhide = `style="display:none;"`;
                    }
                    builder += `<li id="btn${value.plate}" ${btnhide}><button id="${value.plate}" class="qb-jobs-vehicle pageButton" data-plate="${value.plate}" data-selgar="${data.selGar}" data-vehicle="${value.spawn}"><i class="${value.icon}"></i>${value.label}`;
                } else {
                    builder += `<li><button id="${key}" class="qb-jobs-vehicle pageButton" data-selgar="${data.selGar}" data-vehicle="${value.spawn}"><i class="${value.icon}"></i>${value.label}`;
                }
                switch (data.selGar){
                    case "ownGarage":
                        if(value.parkingPrice){builder += `<br />${value.plate}<br /><u><strong>Parking Fee</strong></u><br />$${value.parkingPrice}`}
                    break;
                    case "jobStore":
                        if(value.purchasePrice){builder += `<br /><u><strong>Purchase Price</strong></u><br />$${value.purchasePrice}`}
                    break;
                    case "motorpool":
                        if(value.depositPrice){builder += `<br /><u><strong>Refundable Deposit</strong></u><br />$${value.depositPrice}`}
                        if(value.rentPrice){builder += `<br /><u><strong>Rental Price</strong></u><br />$${value.rentPrice}`}
                    break;
                }
                builder += "</button></li>";
            };
        break;
        case "management":
            if(!btnList[data.type][data.citid].jobHistory[btnList.currentJob].rehireable){builder += `<li class="blackListed"><h3>-- DO NOT HIRE --<br />Black Listed</h3></li>`;}
            data.header = `${btnList[data.type][data.citid].personal.firstName} ${btnList[data.type][data.citid].personal.lastName}`;
            switch(data.type){
                case "applicants":
                    builder += `<li><ul><li><ul class="subMenuCardInLine">`;
                    builder += `<li><button class="actionButton" data-appcid="${data.citid}" data-action="approve"><i class="${btnList.icons.approve}"></i>Approve</button></li>`;
                    builder += `<li><button class="actionButton" data-appcid="${data.citid}" data-action="deny"><i class="${btnList.icons.deny}"></i>Deny</button></li>`;
                    builder += `</ul></li>`;
                break;
                case "employees":
                    builder += `<li><ul><li><ul class="subMenuCardInLine">`;
                    builder += `<li><button class="actionButton" data-appcid="${data.citid}" data-action="promote"><i class="${btnList.icons.promote}"></i>Promote</button></li>`;
                    builder += `<li><button class="actionButton" data-appcid="${data.citid}" data-action="demote"><i class="${btnList.icons.demote}"></i>Demote</button></li>`;
                    builder += `<li><button class="actionButton" data-appcid="${data.citid}" data-action="pay"><i class="${btnList.icons.pay}"></i>Adjust Pay</button></li>`;
                    builder += `<li><button class="actionButton" data-appcid="${data.citid}" data-action="fire"><i class="${btnList.icons.fire}"></i>Terminate</button></li>`;
                    builder += `</ul></li>`;
                break;
                case "pastEmployees":
                    // added this for future mainMenuButtons (maybe)
                break;
                case "deniedApplicants":
                    builder += `<li><ul><li><ul class="subMenuCardInLine">`;
                    builder += `<li><button class="actionButton" data-appcid="${data.citid}" data-action="apply"><i class="${btnList.icons.deny}"></i>Reconsider</button></li>`;
                    builder += `</ul></li>`;
                break;
            }
            builder += `<li><ul><li><button class="subMenuButton" data-id="subMenu${btnCnt}"><i class="${btnList.icons.personal}"></i>Personal</button><ul class="subMenuCard" id="subMenuCard${btnCnt}">`;
            builder += `<li>Phone Number: ${btnList[data.type][data.citid].personal.phone}</li>`;
            builder += `<li>Gender: ${btnList[data.type][data.citid].personal.gender}</li>`;
            builder += `</ul></li>`;
            btnCnt++;
            if(btnList[data.type][data.citid].jobHistory) {
                $.each(btnList[data.type][data.citid].jobHistory, function(k,v){
                    b1 = `<li><ul class="subMenuCard" id="subMenuCard${btnCnt}">`;
                    b1 += `<li><h3>${k}</h3></li>`;
                    b1 += `<li><table><caption>Stats</caption>`
                    b1 += `<tr><th>Applied</th><th>Hired</th><th>Denied</th></tr>`;
                    b1 += `<tr><td>${v.applycount}</td><td>${v.hiredcount}</td><td>${v.denycount}</td></tr>`
                    b1 += `<tr><th>Quit</th><th>Fired</th><th>Grades</th></tr>`
                    b1 += `<td>${v.quitcount}</td><td>${v.firedcount}</td><td>${v.gradechangecount}</td></tr>`;
                    b1 += `</table></li>`;
                    if(k == btnList.currentJob){
                        status["current"] = b1;
                        status["current"] += `<li>Awards<ul>`;
                        $.each(v.awards, function(_,v1){
                            status["current"] += `<li>${v1}</li>`;
                        })
                        status["current"] += `</ul></li>`; // end awards
                        status["current"] += `<li>Write Ups<ul>`;
                        $.each(v.writeups, function(_,v1){
                            status["current"] += `<li>${v1}</li>`;
                        })
                        status["current"] += `</ul></li>`; // end write ups
                        status["current"] += `<li>Details<ul>`;
                        $.each(v.details, function(_,v1){
                            status["current"] += `<li>${v1}</li>`;
                        })
                        status["current"] += `</ul></li>`; // end details
                        status["current"] += `</ul></li>`; // end job history
                    }
                    switch(v.status){
                        case "pending":
                            status["pending"] = b1;
                            status["pending"] += `</ul></li>`;
                        break;
                        case "hired":
                            if(k != btnList.currentJob){
                                status["hired"] = b1;
                                status["hired"] += `</ul></li>`;
                            }
                        break;
                        case "fired":
                            status["fired"] = b1;
                            status["fired"] += `</ul></li>`;
                        break;
                        case "quit":
                            status["quit"] = b1;
                            status["quit"] += `</ul></li>`;
                        break;
                        case "blackListed":
                            status["blackListed"] = b1;
                            status["blackListed"] += `</ul></li>`;
                        break;
                    }
                });
            }
            if(btnList[data.type][data.citid].rapSheet) {
                status["current"] += `<li><ul><li><button class="subMenuButton" data-id="subMenu${btnCnt}"><i class="${btnList.icons.rapSheet}"></i>Rap Sheet</button><ul class="subMenuCard" id="subMenuCard${btnCnt}">`;
                $.each(btnList[data.type][data.citid].rapSheet, function(k,v){
                    status["current"] += `<li>${k}</li><li>${v}</li>`;
                })
                status["current"] += `</ul></li>`;
            }
            builder += status["current"];
            builder += `<li><button class="subMenuButton" data-id="subMenu${btnCnt}"><i class="${btnList.icons.jobHistory}"></i>Job History</button></li>`;
            btnCnt++;
            builder += status["hired"];
            builder += status["quit"];
            builder += status["fired"];
            builder += status["blackListed"];
            builder += `</ul></li></ul></li>`;
        break;
    }
    $("#subMenuHeader").empty();
    $("#subMenuList").empty();
    $("#subMenuHeader").append(data.header);
    $("#subMenuList").append(builder);
}
/* Main / Root Function */
$(document).ready(function(){
    window.addEventListener('message', function(event) {
        btnList = event.data.btnList;
        Lang = event.data.Lang;
        action = event.data.action;
        uiManipulator();
        $("#mainMenuHeader").append(btnList.header);
        open();
    })
    $("#mainMenuHeader").append(btnList.header);
    $(".draggable").draggable();
/* Development Testing Code */
    action = "garage"
    $("#mainMenuHeader").append(btnList.header);
    open();
});
/* Page Actions */
/** Garage SubMenu **/
$(document).on('click', '.qb-jobs-vehicle-return', function(e){
    e.preventDefault();
    let plate = $(this).data('plate');
    if(btnList.returnVehicle[plate].selGar == "ownGarage") {
        $(`.btn${plate}`).show();
    }
    $.post('https://qb-jobs/delVeh', JSON.stringify(plate), function(result) {
        delete btnList.returnVehicle;
        btnList.returnVehicle = result;
        $(`#${plate}`).remove();
        if ($.isEmptyObject(btnList.returnVehicle)){
            retractSubMenu();
            $("#btnReturnVehicle").remove();
        }
    }, "json");
});
$(document).on('click', '.qb-jobs-vehicle-type', function(e){
    e.preventDefault();
    let data = [];
    data.vehType = $(this).data('vehtype');
    data.selGar = $(this).data('selgar');
    $("#subMenuList").empty();
    subMenu(data);
    extractSubMenu();
});
$(document).on('click', '.qb-jobs-vehicle', function(e){
    e.preventDefault();
    let data = [];
    data[0] = btnList.garage;
    data[1] = $(this).data('vehicle');
    data[2] = $(this).data('selgar');
    if (data[2] === "ownGarage") {data[3] = $(this).data('plate');}
    $.post('https://qb-jobs/selectedVehicle', JSON.stringify(data))
    close();
});
/** Management SubMenu **/
$(document).on("click", ".qb-jobs-management", function(e){
    e.preventDefault();
    let data = {
        type:$(this).data("type"),
        citid:$(this).data("citid")
    };
    subMenu(data);
    extractSubMenu();
});
$(document).on("click", ".actionButton", function(e){
    e.preventDefault();
    let data1 = {
        appcid:$(this).data("appcid"),
        action:$(this).data("action")
    }
    $.post('https://qb-jobs/managementSubMenuActions', JSON.stringify(data1), function(res){
        $("#mainMenuHeader").append(btnList.header);
        switch(data1.action){
            case "deny":
                retractSubMenu();
                delete btnList
                btnList = res.btnList;
                empty();
                $("#mainMenuHeader").append(btnList.header);
                open();
            break;
        }
    })
});
/* Button Controls */
$(document).on('click', ".navButton", function(e){
    e.preventDefault();
    id = $(this).data('id') + "-list";
    menuRoutes(`#${id}`)
});
$(document).on('click', ".subMenuButton", function(e){
    e.preventDefault();
    id = $(this).data('id');
    subMenuRoutes(`#subMenuCard${id}`)
});
$(document).on('click', '#retract', function(e){
    e.preventDefault();
    retractSubMenu()
});
$(document).on('click', '#close', function(e){
    e.preventDefault();
    close();
});
$(document).on('keyup', function(e) {
    if (e.key == "Escape") $("#close").click();
});