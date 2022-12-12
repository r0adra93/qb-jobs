/* Variables */
let vehList = [];
let action = null;
let currentPage = null;
let nextPage = null;
/* Variables for Development */
 const VEHLIST = {"vehicles":{"vehicle":[{"spawn":"ambulance","label":"Ambulance","parkingPrice":125,"purchasePrice":150000,"rentPrice":250,"icon":"fa-solid fa-truck-medical","depositPrice":250}],"helicopter":[{"spawn":"polmav","label":"Air Ambulance","purchasePrice":3000000,"icon":"fa-solid fa-helicopter","rentPrice":250}]},"label":"Medical Services","garage":1,"icons":{"boat":"fa-solid fa-ship","deleteVehicle":"fa-solid fa-trash","jobStore":"fa-solid fa-store","helicopter":"fa-solid fa-helicopter","jobGarage":"fa-solid fa-square-parking","ownGarage":"fa-solid fa-warehouse","vehicle":"fa-solid fa-truck-medical","plane":"fa-solid fa-plane"},"vehiclesForSale":{"vehicle":[{"spawn":"ambulance","label":"Ambulance","parkingPrice":125,"icon":"fa-solid fa-truck-medical","purchasePrice":150000}],"helicopter":[{"spawn":"polmav","label":"Air Ambulance","icon":"fa-solid fa-helicopter","purchasePrice":3000000}]},"allowPurchase":true,"ownedVehicles":{"helicopter":{"0":{"spawn":"polmav","plate":"EMS54321","parkingPrice":125,"purchasePrice":1000,"icon":"fa-solid fa-helicopter","label":"Maverick"}},"vehicle":{"0":{"spawn":"ambulance","plate":"EMS12345","parkingPrice":125,"purchasePrice":1000,"icon":"fa-solid fa-truck-medical","label":"Ambulance"}}},"header":"Medical Services Vehicle Selector"};
vehList = VEHLIST;
/* Navigation */
Open = function() {
    ResetPages();
    $("#container").fadeIn(150, () => {
        $(currentPage).fadeIn(150, () => {
            $("#qb-jobs-header").fadeIn(150);
            $("#buttons").fadeIn(150);
        });
    });
}
Close = function() {
    $(currentPage).fadeOut(150, () => {
        ResetPages();
        $("#container").fadeOut(150, () => {
            Empty();
        });
    })
    $.post('https://qb-jobs/qbJobsCloseMenu')
}
Buttons = function(buttons) {
    $("#buttons-list").empty();
    for (const [key,value] of Object.entries(buttons)) {
        $('#buttons-list').append(`<li class="qb-jobs-return" id="${key}">${value}</li>`);
    };
}
Empty = function() {
    $("#qb-jobs-header").empty();
    $("#qb-jobs-ofs-list").empty();
    $("#qb-jobs-assigned-vehicles-list").empty();
    $("#qb-jobs-vehicle-types-list").empty();
    $("#qb-jobs-vehicles-list").empty();
    $("#buttons-list").empty();
}
ResetPages = function() {
    $("#qb-jobs-header").hide();
    $("#qb-jobs-assigned-vehicles").hide();
    $("qb-jobs-ofs").hide();
    $("#qb-jobs-vehicle-types").hide();
    $("#qb-jobs-vehicles").hide();
    $("#buttons").hide();
}
PageRoutes = function(cP) {
    if (cP == nextPage) {cP = "#fadeOut";}
    $(cP).fadeOut(100, () => {
        $(nextPage).fadeIn(100);
    })
    $(`${cP}-list`).empty();
}
/* Pages */
VehiclesList = function(data) {
    let buttons = [];
    if(!jQuery.isEmptyObject(vehList.vehiclesAssigned)){
        buttons["assignedVehicles"] = "Assigned Vehicles";
    }
    if (vehList.ownedVehicles) {buttons["ownGarage"] = "My Garage"};
    buttons["vehicleDepot"] = "Vehicle Depot";
    if (vehList.allowPurchase) {buttons["jobStore"] = "Vehicle Store"};
    switch (data.selGar){
        case "ownGarage":
            vehicles = vehList.ownedVehicles;
            data.header = `My ${vehList.label} Garage`;
        break;
        case "jobStore":
            vehicles = vehList.vehiclesForSale;
        break;
        case "vehicleDepot":
            vehicles = vehList.vehicles;
            data.header = `${vehList.label} Vehicle Depot`;
        break;
    }
    currentPage = "#qb-jobs-vehicles";
    buttons["cancel"] = "Cancel";
    for (const [key,value] of Object.entries(vehicles[data.vehType])) {
        $("#qb-jobs-vehicles-list").append(`<li class="qb-jobs-veh-sel-list qb-jobs-vehicle ${value.icon}" data-vehicle="${value.spawn}"><p id="qjvli${key}">${value.label}</p></li>`);
        switch (data.selGar){
            case "ownGarage":
                if(value.parkingPrice){$(`#qjvli${key}`).append(`<br />${value.plate}<br /><u><strong>Parking Fee</strong></u><br />$${value.parkingPrice}`)}
            break;
            case "jobStore":
                if(value.purchasePrice){$(`#qjvli${key}`).append(`<br /><u><strong>Purchase Price</strong></u><br />$${value.purchasePrice}`)}
            break;
            case "vehicleDepot":
                if(value.depositPrice){$(`#qjvli${key}`).append(`<br /><u><strong>Refundable Deposit</strong></u><br />$${value.depositPrice}`)}
                if(value.rentPrice){$(`#qjvli${key}`).append(`<br /><u><strong>Rental Price</strong></u><br />$${value.rentPrice}`)}
            break;
        }
    };
    Buttons(buttons);
}
VehicleTypesList = function(data) {
    let buttons = [];
    let vehicles = [];
    if(!jQuery.isEmptyObject(vehList.vehiclesAssigned)){
        buttons["assignedVehicles"] = "Assigned Vehicles";
    }
    switch (data.selGar){
        case "ownGarage":
            vehicles = vehList.ownedVehicles;
            data.header = `My ${vehList.label} Garage`;
            buttons["vehicleDepot"] = "Vehicle Depot";
            if (vehList.allowPurchase) {buttons["jobStore"] = "Vehicle Store"};
        break;
        case "jobStore":
            vehicles = vehList.vehiclesForSale;
            data.header = `${vehList.label} Vehicle Store`;
            if (vehList.ownedVehicles) {buttons["ownGarage"] = "My Garage"};
            buttons["vehicleDepot"] = "Vehicle Depot";
        break;
        case "vehicleDepot":
            vehicles = vehList.vehicles;
            data.header = `${vehList.label} Vehicle Depot`;
            if (vehList.ownedVehicles) {buttons["ownGarage"] = "My Garage"};
            if (vehList.allowPurchase) {buttons["jobStore"] = "Vehicle Store"};
        break;
    }
    $("#qb-jobs-header").empty();
    $("#qb-jobs-header").append(data.header);
    currentPage = "#qb-jobs-vehicle-types";
    buttons["cancel"] = "Cancel";
    Buttons(buttons);
    for (const [key] of Object.entries(vehicles)) {
        $("#qb-jobs-vehicle-types-list").append(`<li class="qb-jobs-vehicle-type ${vehList.icons[key]}" data-selgar="${data.selGar}" data-vehtype="${key}"><h2>${key}</h2></li>`);
    };
}
OwnedFleetStoreList = function() {
    $("#qb-jobs-header").empty();
    $("#qb-jobs-header").append(`${vehList.label} Main Menu`);
    currentPage = "#qb-jobs-ofs";
    let buttons = [];
    buttons["cancel"] = "Cancel";
    Buttons(buttons);
    if (vehList.ownedVehicles) {$("#qb-jobs-ofs-list").append(`<li class="qb-jobs-veh-sel-list qb-jobs-ofs ${vehList.icons.ownGarage}" data-selgar="ownGarage"><h2>My Garage</h2></li>`)}
    $("#qb-jobs-ofs-list").append(`<li class="qb-jobs-veh-sel-list qb-jobs-ofs ${vehList.icons.jobGarage}" data-selgar="vehicleDepot"><h2>Vehicle Depot</h2></li>`)
    if (vehList.allowPurchase) {$("#qb-jobs-ofs-list").append(`<li class="qb-jobs-veh-sel-list qb-jobs-ofs ${vehList.icons.jobStore}" data-selgar="jobStore"><h2>Vehicle Store</h2></li>`)}
}
AssignedVehiclesList = function() {
    $("#qb-jobs-header").empty();
    $("#qb-jobs-header").append(`${vehList.label} Key Return`);
    currentPage = "#qb-jobs-assigned-vehicles";
    let buttons = [];
    if (vehList.ownedVehicles) {buttons["ownGarage"] = "My Garage"};
    buttons["vehicleDepot"] = `${vehList.label} Depot`;
    if (vehList.allowPurchase) {buttons["jobStore"] = "Vehicle Store"};
    buttons["cancel"] = "Cancel";
    Buttons(buttons);
    for (const [key,value] of Object.entries(vehList.vehiclesAssigned)) {
        $("#qb-jobs-assigned-vehicles-list").append(`<li class="qb-jobs-veh-sel-list qb-jobs-assigned-vehicle fa-solid fa-trash" id="${key}" data-selveh="${key}"><h2>${value}</h2></li>`);
    };
}
/* Main / Root Function */
$(document).ready(function(){
    let data = [];
    window.addEventListener('message', function(event) {
        vehList = event.data.vehList;
        action = event.data.action;
        $("qb-jobs-header").empty();
        $("#qb-jobs-header").append(vehList.header);
        switch(action) {
            case "AssignedVehiclesList":
                AssignedVehiclesList();
            break;
            case "OwnedFleetStoreList":
                OwnedFleetStoreList();
            break;
            case "VehicleTypesList":
                VehicleTypesList(data);
            break;
        }
        Open();
    })
/* Development Testing Code */
    data.selGar = "vehicleDepot";
    $("#qb-jobs-header").append(vehList.header);
    OwnedFleetStoreList();
    Open();
});
/* Page Actions */
$(document).on('click', '.qb-jobs-assigned-vehicle', function(e){
    e.preventDefault();
    let cP = currentPage;
    let selVeh = $(this).data('selveh');
    $.post('https://qb-jobs/qbJobsDelVeh', JSON.stringify(selVeh), function(result) {
        delete vehList.vehiclesAssigned;
        vehList.vehiclesAssigned = result;
        $("#"+selVeh).remove();
    }, "json");
    if ($.isEmptyObject(vehList.vehiclesAssigned)) {
        nextPage = "#qb-jobs-vehicles";
        $(nextPage).empty();
        VehicleTypesList();
        PageRoutes(cP);
    }
});
$(document).on('click', '.qb-jobs-ofs', function(e){
    e.preventDefault();
    const cP = currentPage;
    let data = [];
    data.selGar = $(this).data('selgar');
    nextPage = "#qb-jobs-vehicle-types";
    $("#qb-jobs-vehicle-types-list").empty();
    VehicleTypesList(data);
    PageRoutes(cP);
});
$(document).on('click', '.qb-jobs-vehicle-type', function(e){
    e.preventDefault();
    const cP = currentPage;
    let data = [];
    data.vehType = $(this).data('vehtype');
    data.selGar = $(this).data('selgar');
    nextPage = "#qb-jobs-vehicles";
    $("#qb-jobs-vehicles-list").empty();
    VehiclesList(data);
    PageRoutes(cP);
});
$(document).on('click', '.qb-jobs-vehicle', function(e){
    e.preventDefault();
    let data = [];
    data[0] = vehList.garage;
    data[1] = $(this).data('vehicle');
    $.post('https://qb-jobs/qbJobsSelectedVehicle', JSON.stringify(data))
    Close();
});
/* Button Controls */
$(document).on('click', '#assignedVehicles', function(e){
    e.preventDefault();
    let cP = currentPage;
    nextPage = "#qb-jobs-assigned-vehicles";
    $("#qb-jobs-assigned-vehicles-list").empty();
    AssignedVehiclesList();
    PageRoutes(cP);
});
$(document).on('click', '#ownGarage', function(e){
    e.preventDefault();
    const cP = currentPage;
    let data = [];
    data.selGar = "ownGarage"
    nextPage = "#qb-jobs-vehicle-types";
    $("#qb-jobs-vehicle-types-list").empty();
    VehicleTypesList(data);
    PageRoutes(cP);
});
$(document).on('click', '#vehicleDepot', function(e){
    e.preventDefault();
    const cP = currentPage;
    let data = [];
    data.selGar = "vehicleDepot"
    nextPage = "#qb-jobs-vehicle-types";
    $("#qb-jobs-vehicle-types-list").empty();
    VehicleTypesList(data);
    PageRoutes(cP);
});
$(document).on('click', '#jobStore', function(e){
    e.preventDefault();
    const cP = currentPage;
    let data = [];
    data.selGar = "jobStore";
    nextPage = "#qb-jobs-vehicle-types";
    $("#qb-jobs-vehicle-types-list").empty();
    VehicleTypesList(data);
    PageRoutes(cP);
});
$(document).on('click', '#cancel', function(e){
    e.preventDefault();
    Close();
});
