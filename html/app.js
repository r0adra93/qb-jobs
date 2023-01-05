/* Variables */
let btnList = [];
let btnCnt = 0;
let Lang = [];
let trick = 1;
let prevtrick = 0;
let active = ".active";
let id = "";
let action = "";
/* Variables for Testing */
/** Garage **/
/* btnList = {"header":"Medical Services Vehicle Manager","icons":{"helicopter":"fa-solid fa-helicopter","vehicle":"fa-solid fa-truck-medical","retract":"fa-solid fa-angles-left","plane":"fa-solid fa-plane","close":"fa-regular fa-circle-xmark","boat":"fa-solid fa-ship","ownGarage":"fa-solid fa-warehouse","jobGarage":"fa-solid fa-square-parking","returnVehicle":"fa-solid fa-rotate-left","jobStore":"fa-solid fa-store"},"ownedVehicles":{"helicopter":{"0":{"icon":"fa-solid fa-helicopter","plate":"EMS54321","parkingPrice":125,"label":"Maverick","purchasePrice":1000,"spawn":"polmav"}},"vehicle":{"0":{"icon":"fa-solid fa-truck-medical","plate":"EMS12345","parkingPrice":125,"label":"Ambulance","purchasePrice":1000,"spawn":"ambulance"}}},"allowPurchase":true,"vehicles":{"helicopter":[{"rentPrice":250,"parkingPrice":125,"icon":"fa-solid fa-helicopter","label":"Air Ambulance","purchasePrice":3000000,"spawn":"polmav"}],"vehicle":[{"rentPrice":250,"icon":"fa-solid fa-truck-medical","parkingPrice":125,"label":"Ambulance","depositPrice":250,"purchasePrice":150000,"spawn":"ambulance"}]},"vehiclesForSale":{"helicopter":[{"icon":"fa-solid fa-helicopter","parkingPrice":125,"purchasePrice":3000000,"label":"Air Ambulance","spawn":"polmav"}],"vehicle":[{"icon":"fa-solid fa-truck-medical","parkingPrice":125,"purchasePrice":150000,"label":"Ambulance","spawn":"ambulance"}]},"garage":1,"label":"Medical Services","returnVehicle":{"1370114":"ambulance","1369090":"ambulance","1364226":"ambulance","1364738":"ambulance","1366530":"ambulance","1365762":"ambulance","1363970":"ambulance"}};
btnList = btnList;
btnList.icons.retract = "fa-solid fa-angles-left";
/** Management **/
 btnList = {"applicants":[],"deniedApplicants":{"CFO10134":{"rapSheet":[],"personal":{"phone":"6069108880","firstName":"Abdullah ","lastName":"Ali"},"jobHistory":{"reporter":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"hotdog":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"police":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"taxi":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"cardealer":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"vineyard":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"lawyer":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"ambulance":{"writeups":[],"quitcount":0,"details":["Application was Denied"],"gradechangecount":0,"denycount":1,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":2,"status":"denied","awards":[]},"realestate":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"garbage":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"bus":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"unemployed":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"judge":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"mechanic":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"trucker":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"bcso":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"tow":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]}}},"YMG63813":{"rapSheet":[],"personal":{"phone":"7663043589","firstName":"Robert","lastName":"Crews"},"jobHistory":{"reporter":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"hotdog":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"police":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"taxi":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"cardealer":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"vineyard":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"lawyer":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"ambulance":{"writeups":[],"quitcount":0,"details":["Application was Denied"],"gradechangecount":0,"denycount":1,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":1,"status":"denied","awards":[]},"realestate":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"garbage":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"bus":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"unemployed":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"judge":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"mechanic":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"trucker":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"bcso":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"tow":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]}}},"TMY15734":{"rapSheet":[],"personal":{"phone":"2684675351","firstName":"foook","lastName":"noot"},"jobHistory":{"reporter":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"hotdog":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"police":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"taxi":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"cardealer":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"vineyard":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"lawyer":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"ambulance":{"writeups":[],"quitcount":0,"details":["Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied","Application was Denied"],"gradechangecount":0,"denycount":8,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":9,"status":"denied","awards":[]},"realestate":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"garbage":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"bus":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"unemployed":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"judge":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"mechanic":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"trucker":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"bcso":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]},"tow":{"gradechangecount":0,"quitcount":0,"details":[],"writeups":[],"grades":[],"denycount":0,"rehireable":true,"status":"available","firedcount":0,"applycount":0,"hiredcount":0,"awards":[]}}},"HQQ55159":{"rapSheet":[],"personal":{"phone":"1592797008","firstName":"mot","lastName":"mot"},"jobHistory":{"reporter":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"hotdog":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"police":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"taxi":{"writeups":[],"quitcount":0,"details":["was hired by taxi"],"gradechangecount":0,"denycount":0,"hiredcount":1,"rehireable":true,"firedcount":0,"applycount":0,"status":"hired","awards":[]},"cardealer":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"vineyard":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"lawyer":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"ambulance":{"writeups":[],"quitcount":0,"details":["Application was Denied"],"gradechangecount":0,"denycount":1,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":1,"status":"denied","awards":[]},"realestate":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"garbage":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"bus":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"unemployed":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"judge":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"mechanic":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"trucker":{"writeups":[],"quitcount":0,"details":["was hired by trucker"],"gradechangecount":0,"denycount":0,"hiredcount":1,"rehireable":true,"firedcount":0,"applycount":0,"status":"hired","awards":[]},"bcso":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"tow":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]}}},"ATE85065":{"rapSheet":[],"personal":{"phone":"7342854485","firstName":"John","lastName":"Doe"},"jobHistory":{"reporter":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"hotdog":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"police":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"taxi":{"writeups":[],"quitcount":0,"details":["was hired by taxi","was hired by taxi"],"hiredcount":2,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"hired","awards":[]},"cardealer":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"vineyard":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"lawyer":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"ambulance":{"writeups":[],"quitcount":0,"details":["Application was Denied"],"gradechangecount":0,"denycount":1,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":1,"status":"denied","awards":[]},"realestate":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"garbage":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"bus":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"unemployed":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"judge":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"mechanic":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"trucker":{"writeups":[],"quitcount":0,"details":["was hired by trucker","was hired by trucker","was hired by trucker"],"hiredcount":3,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"hired","awards":[]},"bcso":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"tow":{"writeups":[],"quitcount":0,"details":[],"hiredcount":0,"denycount":0,"gradechangecount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]}}},"MTQ14036":{"rapSheet":[],"personal":{"phone":"6197775419","firstName":"Little","lastName":"Rager"},"jobHistory":{"reporter":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"hotdog":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"police":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"taxi":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"cardealer":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"vineyard":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"lawyer":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"ambulance":{"writeups":[],"quitcount":0,"details":["Application was Denied","Application was Denied"],"gradechangecount":0,"denycount":2,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":2,"status":"denied","awards":[]},"realestate":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"garbage":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"bus":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"unemployed":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"judge":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"mechanic":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"trucker":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"bcso":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"tow":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]}}}},"currentJob":"ambulance","header":"Medical Services Boss Menu","pastEmployees":[],"icons":{"pastEmployees":"fa-solid fa-users-slash","fire":"fa-solid fa-ban","rapSheet":"fa-solid fa-handcuffs","personal":"fa-solid fa-person-circle-exclamation","deniedApplicant":"fa-solid fa-user-slash","demote":"fa-regular fa-thumbs-down","deny":"fa-regular fa-circle-xmark","deniedApplicants":"fa-solid fa-users-slash","applicants":"fa-solid fa-users-rectangle","applicant":"fa-solid fa-user","retract":"fa-solid fa-angles-left","pay":"fa-solid fa-hand-holding-dollar","close":"fa-solid fa-x","pastEmployee":"fa-solid fa-user-slash","approve":"fa-regular fa-circle-check","promote":"fa-regular fa-thumbs-up","employees":"fa-solid fa-users","jobHistory":"fa-regular fa-address-card","employee":"fa-solid fa-user"},"writeUps":[{"title":"Malpractice","description":"Making a mistake while treating a patient"},{"title":"Insubordination","description":"Failure to follow directions."},{"title":"Unsafe Behavior","description":"Failure to follow safety guidelines."},{"title":"No Call / No Show","description":"Fails to call out & fails to show up."},{"title":"Other","description":"Any reason that necessitates a write up."}],"employees":{"SPC88576":{"rapSheet":[],"personal":{"phone":"3435606634","lastName":"Test","firstName":"Test","position":{"name":"No Grades","level":0}},"jobHistory":{"reporter":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"hotdog":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"police":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"taxi":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"cardealer":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"vineyard":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"lawyer":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"ambulance":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":2,"rehireable":true,"firedcount":0,"applycount":0,"status":"hired","awards":[]},"realestate":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"garbage":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"bus":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"unemployed":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"judge":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"mechanic":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"trucker":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"bcso":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]},"tow":{"writeups":[],"quitcount":0,"details":[],"gradechangecount":0,"denycount":0,"hiredcount":0,"rehireable":true,"firedcount":0,"applycount":0,"status":"available","awards":[]}}}},"status":{"pending":"Pending","blacklisted":"Black Listed","hired":"Hired","quit":"Quit","fired":"Fired"},"awards":[{"title":"Award of Excellence","description":"Awarded for going above and beyond service to patients."},{"title":"Honorable Action","description":"Awarded for saving a life with risk to life and limb. While on duty or off duty."},{"title":"Meritous Action","description":"Awarded for saving a life while off duty. Not looking away when others could be of service."},{"title":"Medical Heart Award","description":"Awarded for being wounded on the mean streets of San Andreas."}]}
/** Navigation **/
open = (action) => {
    resetMenus();
    mainMenu(action);
    resetMainMenu();
    $("#container").fadeIn(150, () => {
        $("#mainMenuContainer").fadeIn(0, () => {
            $("#mainMenuHeader").fadeIn(0);
            $("#mainMenuButtons").fadeIn(0);
        });
    });
}
close = () => {
    retractSubMenu()
    $("#container").fadeOut(150, () => {
        resetMenus();
        empty();
    });
    $.post('https://qb-jobs/closeMenu')
}
extractSubMenu = () => {
   $("#subMenuContainer").addClass("Open");
}
retractSubMenu = () => {
    $("#subMenuContainer").removeClass("Open");
}
empty = () => {
    $("#mainMenuHeader").empty();
    $("#mainMenuButtons").empty();
    $("#subMenuHeader").empty();
    $("#subMenu").empty();
    $("#subMenuContainer").removeClass("Open");
}
resetMainMenu = () => {
    for(let i = 0; i <= btnCnt; i++){
        $(`#nav${i}-list`).hide();
        $(`#subMenuCard${i}`).hide();
    }
}
resetMenus = () => {
    $("#mainMenuContainer").fadeOut();
    $("#mainMenuHeader").hide();
    $("#mainMenuButtons").hide();
    // $("#subMenuContainer").hide();
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
    let builder = `<ul id="mainMenuButtonsList">`;
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
    builder += `</ul>`;
    $("#mainMenuButtons").append(builder);
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
            builder += `<ul class="subMenuList">`;
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
            builder += "</ul>"
        break;
        case "management":
            if(!btnList[data.type][data.citid].jobHistory[btnList.currentJob].rehireable){builder += `<li class="blackListed"><h3>-- DO NOT HIRE --<br />Black Listed</h3></li>`;}
            data.header = `${btnList[data.type][data.citid].personal.firstName} ${btnList[data.type][data.citid].personal.lastName}`;
            switch(data.type){
                case "applicants":
                    builder += `<button class="actionButton" data-appcid="${data.citid}" data-action="approve"><i class="${btnList.icons.approve}"></i>Approve</button>`;
                    builder += `<button class="actionButton" data-appcid="${data.citid}" data-action="deny"><i class="${btnList.icons.deny}"></i>Deny</button>`;
                break;
                case "employees":
                    builder += `<button class="actionButton" data-appcid="${data.citid}" data-action="promote"><i class="${btnList.icons.promote}"></i>Promote</button>`;
                    builder += `<button class="actionButton" data-appcid="${data.citid}" data-action="demote"><i class="${btnList.icons.demote}"></i>Demote</button>`;
                    builder += `<button class="actionButton" data-appcid="${data.citid}" data-action="pay"><i class="${btnList.icons.pay}"></i>Adjust Pay</button>`;
                    builder += `<button class="actionButton" data-appcid="${data.citid}" data-action="fire"><i class="${btnList.icons.fire}"></i>Terminate</button>`;
                break;
                case "pastEmployees":
                    // added this for future mainMenuButtons (maybe)
                break;
                case "deniedApplicants":
                    builder += `<button class="actionButton" data-appcid="${data.citid}" data-action="apply"><i class="${btnList.icons.deny}"></i>Reconsider</button>`;
                break;
            }
            builder += `<button class="subMenuButton" data-id="${btnCnt}"><i class="${btnList.icons.personal}"></i>Personal</button>`;
            builder += `<ul class="subMenuCard" id="${btnCnt}">`;
            btnCnt++;
            builder += `<li>Phone Number: ${btnList[data.type][data.citid].personal.phone}</li>`;
            builder += `<li>Gender: ${btnList[data.type][data.citid].personal.gender}</li>`;
            builder += `</ul>`;
            btnCnt++;
            if(btnList[data.type][data.citid].jobHistory) {
                $.each(btnList[data.type][data.citid].jobHistory, function(k,v){
                    b1 = `<button class="subMenuSubButton"  data-id="${btnCnt}"><h3>Records at ${k}</h3></button>`;
                    if(k === btnList.currentJob){b1 = `<button class="subMenuSubButton" data-id="${btnCnt}"><h3>Our Records</h3></button>`;}
                    b1 += `<ul class="subMenuCard" id="${btnCnt}">`;
                    btnCnt++;
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
                        status["current"] += `</ul></li></ul>`; // end details
                    }
                    b1 += `</ul>`
                    switch(v.status){
                        case "pending":
                            status["pending"] = b1;
                        break;
                        case "hired":
                            if(k !== btnList.currentJob){
                                status["hired"] = b1;
                            }
                        break;
                        case "fired":
                            status["fired"] = b1;
                        break;
                        case "quit":
                            status["quit"] = b1;
                        break;
                        case "blackListed":
                            status["blackListed"] = b1;
                        break;
                    }
                });
            }
            status["current"] += `<button class="subMenuSubButton" data-id="${btnCnt}"><i class="${btnList.icons.rapSheet}"></i>Rap Sheet</button>`;
            status["current"] += `<ul class="subMenuCard" id="${btnCnt}">`;
            btnCnt++
            if(!$.isEmptyObject(btnList[data.type][data.citid].rapSheet)) {
                $.each(btnList[data.type][data.citid].rapSheet, function(k,v){
                    status["current"] += `<li>${k}</li><li>${v}</li>`;
                })
            }else{status["current"] += `<li>No Criminal Record</li>`}
            status["current"] += `</ul>`;
            builder += status["current"];
            builder += `<button class="subMenuButton" data-id="${btnCnt}"><i class="${btnList.icons.jobHistory}"></i>Job History</button>`;
            builder += `<div id="jobHistoryCard" data-id="${btnCnt}">`
            btnCnt++;
            builder += status["hired"];
            builder += status["quit"];
            builder += status["fired"];
            builder += status["blackListed"];
            builder += `</div>`;
        break;
    }
    $("#subMenuHeader").empty();
    $("#subMenu").empty();
    $("#subMenuHeader").append(`<button id="retractButton"><i class="${btnList.icons.retract}"></i></button>`)
    $("#subMenuHeader").append(data.header);
    $("#subMenu").append(builder);
}
appendMainMenuHeader = () => {
    $("#mainMenuHeader").append(`<button id="closeButton"><i class="${btnList.icons.close}"></i></button>`)
    $("#mainMenuHeader").append(btnList.header);
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

    action = "management"
    appendMainMenuHeader();
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
    $("#subMenu").empty();
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
        appendMainMenuHeader();
        switch(data1.action){
            case "deny":
                retractSubMenu();
                delete btnList
                btnList = res.btnList;
                empty();
                appendMainMenuHeader();
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
    subMenuRoutes(`#${id}`)
});
$(document).on('click', ".subMenuSubButton", function(e){
    e.preventDefault();
    id = $(this).data('id');
    subMenuRoutes(`#${id}`)
});
$(document).on('click', '#retractButton', function(e){
    e.preventDefault();
    retractSubMenu()
});
$(document).on('click', '#closeButton', function(e){
    e.preventDefault();
    close();
});
$(document).on('keyup', function(e) {
    if (e.key == "Escape") $("#close").click();
});