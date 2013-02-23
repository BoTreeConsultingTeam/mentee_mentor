// Reference: http://developmentmode.wordpress.com/2011/05/09/defining-custom-functions-on-jquery/
(function($) {

}) (jQuery);

// Below used statement is the shortcut for jQuery(document).ready(function() {});
jQuery(function() {

  var professionalProfileSectionSelector = '#professionalProfileSection';
  var professionalProfileSection = $(professionalProfileSectionSelector).length > 0;

  if(professionalProfileSection) {
    var dateDisplayFormat = 'M yy';
    // This is for attaching datepicker to already saved details and rendered
    // in edit mode.
    attachDatepicker($(professionalProfileSectionSelector).find('.datepicker'), dateDisplayFormat);

    var experienceTemplateSelector = '#editProfile #experienceTemplate';
    var workExperienceContainerSelector = professionalProfileSectionSelector + ' ' + '#workExperienceContainer';
    var addExperienceBtnSelector = professionalProfileSectionSelector + ' ' + '#addExperienceBtn';

    $(addExperienceBtnSelector).click(function() {
      //TODO: Fix a Javascript bug.When more than one experience/education is
      // being added, selecing a date from the datepicker does not display in
      // text-field the datepicker opened up for and rather updates the
      // value in the first date field in the first row.
      $(workExperienceContainerSelector).append($(experienceTemplateSelector).html());
      attachDatepicker($(workExperienceContainerSelector).find('.datepicker'), dateDisplayFormat);
    });

    var educationTemplateSelector = '#editProfile #educationTemplate';
    var educationContainerSelector = professionalProfileSectionSelector + ' ' + '#educationContainer';
    var addEducationBtnSelector = professionalProfileSectionSelector + ' ' + '#addEducationBtn';

    $(addEducationBtnSelector).click(function() {
      $(educationContainerSelector).append($(educationTemplateSelector).html());
      attachDatepicker($(educationContainerSelector).find('.datepicker'), dateDisplayFormat);
    });

    var removeDetailsBtnSelector = 'a.delete';
    $(removeDetailsBtnSelector).live('click', function() {
      var parent = $(this).parent();
      var parentParent = parent.parent();
      var isWorkExperienceContainer = parentParent.is('#workExperienceContainer');
      var isEducationContainer = parentParent.is('#educationContainer');
      if (isWorkExperienceContainer) {
        var experienceId = parent.find('.experienceId').val();
        //alert("Experience Id:" + experienceId);
        parent.html($('#editProfile #removeExperienceTemplate').html());
        parent.find('.experienceId').val(experienceId);
        parent.find('.experienceDestroy').val('1');
      } else if(isEducationContainer) {
        var educationId = parent.find('.educationId').val();
        //alert("Education Id:" + educationId);
        parent.html($('#editProfile #removeEducationTemplate').html());
        parent.find('.educationId').val(educationId);
        parent.find('.educationDestroy').val('1');
      }

      parent.hide();
    });
  }

});