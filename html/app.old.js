/* Variables */
let btnList = [];
let idCnt = 0;
let Lang = [];
let trick = 1;
let prevtrick = 0;
let active = ".active";
/* Variables for Development */
/*const btnList = {"header":"Medical Services Vehicle Manager","icons":{"helicopter":"fa-solid fa-helicopter","vehicle":"fa-solid fa-truck-medical","retract":"fa-solid fa-angles-left","plane":"fa-solid fa-plane","close":"fa-regular fa-circle-xmark","boat":"fa-solid fa-ship","ownGarage":"fa-solid fa-warehouse","jobGarage":"fa-solid fa-square-parking","returnVehicle":"fa-solid fa-rotate-left","jobStore":"fa-solid fa-store"},"ownedVehicles":{"helicopter":{"0":{"icon":"fa-solid fa-helicopter","plate":"EMS54321","parkingPrice":125,"label":"Maverick","purchasePrice":1000,"spawn":"polmav"}},"vehicle":{"0":{"icon":"fa-solid fa-truck-medical","plate":"EMS12345","parkingPrice":125,"label":"Ambulance","purchasePrice":1000,"spawn":"ambulance"}}},"allowPurchase":true,"vehicles":{"helicopter":[{"rentPrice":250,"parkingPrice":125,"icon":"fa-solid fa-helicopter","label":"Air Ambulance","purchasePrice":3000000,"spawn":"polmav"}],"vehicle":[{"rentPrice":250,"icon":"fa-solid fa-truck-medical","parkingPrice":125,"label":"Ambulance","depositPrice":250,"purchasePrice":150000,"spawn":"ambulance"}]},"vehiclesForSale":{"helicopter":[{"icon":"fa-solid fa-helicopter","parkingPrice":125,"purchasePrice":3000000,"label":"Air Ambulance","spawn":"polmav"}],"vehicle":[{"icon":"fa-solid fa-truck-medical","parkingPrice":125,"purchasePrice":150000,"label":"Ambulance","spawn":"ambulance"}]},"garage":1,"label":"Medical Services","returnVehicle":{"1370114":"ambulance","1369090":"ambulance","1364226":"ambulance","1364738":"ambulance","1366530":"ambulance","1365762":"ambulance","1363970":"ambulance"}};
btnList = btnList;
btnList.icons.retract = "fa-solid fa-angles-left";*/
/* Navigation */
Open = (action) => {
    ResetPages();
    Buttons(action);
    ResetButtons();
    $("#container").fadeIn(150, () => {
        $("#qb-jobs-main-menu-container").fadeIn(150, () => {
            $("#qb-jobs-header").fadeIn(150);
            $("#buttons").fadeIn(150);
        });
    });
}
Close = () => {
    $("#qb-jobs-sub-menu-container").fadeOut(150, () => {
        ResetPages();
        $("#container").fadeOut(150, () => {
            Empty();
        });
    })
    $.post('https://qb-jobs/qbJobsCloseMenu')
}
retractSubMenu = () => {
    $("#qb-jobs-sub-menu-container").animate({left:"30vh"}).hide();
}
Buttons = (action) => {
    let builder = "";
    switch(action) {
        case "garage":
            if (btnList.ownedVehicles) {
                builder += `<li><button id="ownGarage" class="navButton"><i class="${btnList.icons.ownGarage}"></i>My Garage</button><ul id="ownGarage-type">`;
                for (const [key] of Object.entries(btnList.ownedVehicles)) {
                    builder += `<li><button class="qb-jobs-vehicle-type navSubButton" data-selgar="ownGarage" data-vehtype="${key}"><i class="${btnList.icons[key]}"></i>${key}</li>`;
                };
                builder += "</ul></li>";
            }
            builder += `<li><button id="motorpool" class="navButton"><i class="${btnList.icons.jobGarage}"></i>Motorpool</button><ul id="motorpool-type">`;
            for (const [key] of Object.entries(btnList.vehicles)) {
                builder += `<li><button class="qb-jobs-vehicle-type navSubButton" data-selgar="motorpool" data-vehtype="${key}"><i class="${btnList.icons[key]}"></i>${key}</li>`;
            };
            builder += `</ul></li>`;
            if (btnList.allowPurchase) {
                builder += `<li><button id="jobStore" class="navButton"><i class="${btnList.icons.jobStore}"></i>Vehicle Shop</button><ul id="jobStore-type">`;
                for (const [key] of Object.entries(btnList.vehiclesForSale)) {
                    builder += `<li><button class="qb-jobs-vehicle-type navSubButton" data-selgar="jobStore" data-vehtype="${key}"><i class="${btnList.icons[key]}"></i>${key}</li>`;
                };
                builder += "</ul></li>";
            }
            if(!jQuery.isEmptyObject(btnList.returnVehicle)){
                builder += `<li id="btnReturnVehicle"><button id="returnVehicle" class="qb-jobs-vehicle-type navButton" data-vehtype="returnVehicle" data-selgar="returnVehicle"><i class="${btnList.icons.returnVehicle}"></i>Return Vehicles</button></li>`;
            }
            break;
        case "management":
            if (!jQuery.isEmptyObject(btnList.applicants)) {
                builder += `<li><button id="applicants" class="navButton"><i class="${btnList.icons.applicants}"></i>Applicants</button><ul id="applicant-list">`;
                for (const [key] of Object.entries(btnList.applicants)) {
                    builder += `<li><button class="qb-jobs-applicant navSubButton"><i class="${btnList.icons.applicant}"></i>${key}</li>`;
                };
                builder += "</ul></li>";
            }
            if (!jQuery.isEmptyObject(btnList.employees)) {
                builder += `<li><button id="employees" class="navButton"><i class="${btnList.icons.employees}"></i>Employees</button><ul id="employee-list">`;
                for (const [key] of Object.entries(btnList.employees)) {
                    builder += `<li><button class="qb-jobs-employee navSubButton"><i class="${btnList.icons.employee}"></i>${key}</li>`;
                };
                builder += "</ul></li>";
            }
            if (!jQuery.isEmptyObject(btnList.pastEmployees)) {
                builder += `<li><button id="pastEmployees" class="navButton"><i class="${btnList.icons.employees}"></i>Employees</button><ul id="pastEmployee-list">`;
                for (const [key] of Object.entries(btnList.pastEmployees)) {
                    builder += `<li><button class="qb-jobs-pastEmployee navSubButton"><i class="${btnList.icons.employee}"></i>${key}</li>`;
                };
                builder += "</ul></li>";
            }
            break;
    }
    $("#buttons-list").append(builder);
    $("#close").append(`<button id="close-button" class="close"><i class="${btnList.icons.close}"></i>Close</button>`)
    $("#retract").append(`<button id="retract-button" class="retract"><i class="${btnList.icons.retract}"></i>Retract</button>`)
}
Empty = () => {
    $("#qb-jobs-header").empty();
    $("#buttons-list").empty();
    $("#qb-jobs-list").empty();
}
ResetButtons = () => {
    $("#ownGarage-type").hide();
    $("#motorpool-type").hide();
    $("#jobStore-type").hide();
    $("#returnVehicle-type").hide();
}
ResetPages = () => {
    $("#qb-jobs-main-menu-container").hide();
    $("#qb-jobs-header").hide();
    $("#buttons").hide();
    $("#qb-jobs-sub-menu-container").hide();
    ResetButtons();
}
PageRoutes = (step) => {
    if($(step).hasClass("tempClass")) {
        $(".tempClass").removeClass("tempClass");
    }else{
        $(".tempClass").slideUp();
        $(".tempClass").removeClass("tempClass");
    }
    $(step).slideToggle();
    $(step).addClass("tempClass");
}
UiManipulator = () => {
    for (const [_,v] of Object.entries(btnList.uiColors)) {
        $('head').append("<style>"+v.element+"{"+v.property+":"+v.value+";}</style>");
    }
}
/* Pages */
VehiclesList = (data) => {
    let vehicles = [];
    let builder = "";
    switch (data.selGar){
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
    $("#qb-jobs-sub-menu-header").empty();
    $("#qb-jobs-sub-menu-header").append(data.header);
    $("#qb-jobs-list").append(builder);
}
/* Main / Root Function */
$(document).ready(function(){
    window.addEventListener('message', function(event) {
        btnList = event.data.btnList;
        Lang = event.data.Lang;
        UiManipulator();
        $("#qb-jobs-header").append(btnList.header);
        Open(event.data.action);
    })
    $("#qb-jobs-header").append(btnList.header);
    $(".draggable").draggable();
/* Development Testing Code */
/*    $("#qb-jobs-header").append(btnList.header);
    Open(); */
});
/* Page Actions */
$(document).on('click', '.qb-jobs-vehicle-return', function(e){
    e.preventDefault();
    let plate = $(this).data('plate');
    if(btnList.returnVehicle[plate].selGar == "ownGarage") {
        $(`.btn${plate}`).show();
    }
    $.post('https://qb-jobs/qbJobsDelVeh', JSON.stringify(plate), function(result) {
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
    $("#qb-jobs-list").empty();
    VehiclesList(data);
    $("#qb-jobs-sub-menu-container").animate({left:"30vh"}).show();
});
$(document).on('click', '.qb-jobs-vehicle', function(e){
    e.preventDefault();
    let data = [];
    data[0] = btnList.garage;
    data[1] = $(this).data('vehicle');
    data[2] = $(this).data('selgar');
    if (data[2] === "ownGarage") {data[3] = $(this).data('plate');}
    $.post('https://qb-jobs/qbJobsSelectedVehicle', JSON.stringify(data))
    Close();
});
/* Button Controls */
$(document).on('click', '#ownGarage', function(e){
    e.preventDefault();
    PageRoutes("#ownGarage-type")
});
$(document).on('click', '#motorpool', function(e){
    e.preventDefault();
    PageRoutes("#motorpool-type")
});
$(document).on('click', '#jobStore', function(e){
    e.preventDefault();
    PageRoutes("#jobStore-type")
});
$(document).on('click', '#retract', function(e){
    e.preventDefault();
    retractSubMenu()
});
$(document).on('click', '#close', function(e){
    e.preventDefault();
    Close();
});
$(document).on('keyup', function(e) {
    if (e.key == "Escape") $("#close").click();
  });