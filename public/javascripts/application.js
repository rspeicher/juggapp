$(function() {
    $('#applicant_character_server').change(populateArmory);
    $('#applicant_character_name').change(populateArmory);
});

function populateArmory() {
    // if ($('#applicant_armory_link').val() != '') {
    //     return false;
    // }
    
    cserver = $('#applicant_character_server').val();
    cname   = $('#applicant_character_name').val();
    
    $('#applicant_armory_link').val("http://www.wowarmory.com/character-sheet.xml?r=" + cserver + "&n=" + cname);
    $('#applicant_armory_link').effect('highlight', {}, 1500);
}