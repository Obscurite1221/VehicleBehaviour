window.addEventListener('message', function(event) {
    var item = event.data;
    if (item.action == 'showUI')
        $('.MenuDiv').show();
    else if (item.action == 'hideUI')
        $('.MenuDiv').hide();
    else if (item.action == 'diffVehicle')  {
        $.post("https://VehicleBehaviour/populateFields");
    }
    else if (item.action == 'populateFields') {
            document.getElementById('vehMassInput').value=item.f_mass;
            document.getElementById('vehDragCoeff').value=item.f_InitialDragCoeff;
            document.getElementById('vehCenterOfMassx').value=item.Vec3_CenterOfMass.x;
            document.getElementById('vehCenterOfMassy').value=item.Vec3_CenterOfMass.y;
            document.getElementById('vehCenterOfMassz').value=item.Vec3_CenterOfMass.z;
            document.getElementById('vehInertiaMultx').value=item.Vec3_InertiaMult.x;
            document.getElementById('vehInertiaMulty').value=item.Vec3_InertiaMult.y;
            document.getElementById('vehInertiaMultz').value=item.Vec3_InertiaMult.z;
            document.getElementById('vehDriveBias').value=item.f_DriveBias;
            document.getElementById('vehNumGears').value=item.i_numGears;
            document.getElementById('vehDriveInertia').value=item.f_DriveInertia;
            document.getElementById('vehTopSpeed').value=item.f_TopSpeed;
            document.getElementById('vehBrakingForce').value=item.f_BrakingForce;
            document.getElementById('vehInitialDriveForce').value=item.f_InitialDriveForce;
            //document.getElementById('vehMassInput').value=item.f_MaxSteerAngle
    }
        
});

document.addEventListener("keydown", (event) => {
    if(event.key == "h")
    {
        $.post("https://VehicleBehaviour/closeMenu");
        $('.MenuDiv').hide();
    }
});

function updateVehicle() {
    $.post("https://VehicleBehaviour/updateVehicle", JSON.stringify({
        f_mass : document.getElementById('vehMassInput').value,
        f_InitialDragCoeff : document.getElementById('vehDragCoeff').value,
        Vec3_CenterOfMass_x : document.getElementById('vehCenterOfMassx').value,
        Vec3_CenterOfMass_y : document.getElementById('vehCenterOfMassy').value,
        Vec3_CenterOfMass_z : document.getElementById('vehCenterOfMassz').value,
        Vec3_InertiaMult_x : document.getElementById('vehInertiaMultx').value,
        Vec3_InertiaMult_y : document.getElementById('vehInertiaMulty').value,
        Vec3_InertiaMult_z : document.getElementById('vehInertiaMultx').value,
        f_DriveBias : document.getElementById('vehDriveBias').value,
        i_numGears : document.getElementById('vehNumGears').value,
        f_DriveInertia : document.getElementById('vehDriveInertia').value,
        f_TopSpeed : document.getElementById('vehTopSpeed').value,
        f_BrakingForce : document.getElementById('vehBrakingForce').value,
        f_InitialDriveForce : document.getElementById('vehInitialDriveForce').value
    }));
};


$(function() {
    $('.MenuDiv').hide();
});