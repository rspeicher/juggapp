$(function() {
    $('#applicant_server_id').change(populateArmory);
    $('#applicant_character_name').change(populateArmory);
});

function populateArmory() {
    cserver = $('#applicant_server_id :selected').text().replace(/\s/, '-').replace(/[^A-Za-z0-9\-]/, '').toLowerCase();
    cname   = $('#applicant_character_name').val().toLowerCase();

    $('#applicant_armory_link').val("http://us.battle.net/wow/en/character/" + cserver + "/" + cname + "/advanced");
    $('#applicant_armory_link').effect('highlight', {}, 1500);
}
