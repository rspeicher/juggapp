$(function() {
    $('#applicant_applicant_character_attributes_server_id').change(populateArmory);
    $('#applicant_applicant_character_attributes_current_name').change(populateArmory);
});

function populateArmory() {
    // if ($('#applicant_armory_link').val() != '') {
    //     return false;
    // }

    cserver = escape($('#applicant_applicant_character_attributes_server_id :selected').text());
    cname   = escape($('#applicant_applicant_character_attributes_current_name').val());

    $('#applicant_applicant_character_attributes_armory_link').val("http://www.wowarmory.com/character-sheet.xml?r=" + cserver + "&n=" + cname);
    $('#applicant_applicant_character_attributes_armory_link').effect('highlight', {}, 1500);
}