// Reference: http://developmentmode.wordpress.com/2011/05/09/defining-custom-functions-on-jquery/
(function($) {

    getProfessionalProfileDisplayDateFormat = function() {
      return 'M yy';
    };

    getExperienceTemplateSelector = function() {
      return '#editProfile #experienceTemplate';
    };

    getEducationTemplateSelector = function() {
      return '#editProfile #educationTemplate';
    };

    getProfessionalProfileSectionSelector = function() {
      return '#professionalProfileSection';
    };

    getWorkExperienceContainerSelector = function() {
      return getProfessionalProfileSectionSelector() + ' ' + '#workExperienceContainer';
    };

    getAddExperienceBtnSelector = function() {
      return getProfessionalProfileSectionSelector() + ' ' + '#addExperienceBtn';
    };

    getExperienceDateFieldSelector = function() {
      return getWorkExperienceContainerSelector() + ' ' + '.datepicker';
    };

    getEducationContainerSelector = function() {
      return getProfessionalProfileSectionSelector() + ' ' + '#educationContainer';
    };

    getAddEducationBtnSelector = function() {
      return getProfessionalProfileSectionSelector() + ' ' + '#addEducationBtn';
    };

    getEducationDateFieldSelector = function() {
      return getEducationContainerSelector() + ' ' + '.datepicker';
    };

    // Intended to be used for Professional Profile section's Experience
    // and Education delete buttons
    bindClickToRemoveDetailsBtn = function() {
      var removeDetailsBtnSelector = '#professionalProfileSection a.delete';
      $(removeDetailsBtnSelector).on('click', function() {
        var parent = $(this).parent();
        var parentParent = parent.parent();
        var isWorkExperienceContainer = parentParent.is('#workExperienceContainer');
        var isEducationContainer = parentParent.is('#educationContainer');
        var removeFromDom = false;
        var hide = false;
        if (isWorkExperienceContainer) {
          var experienceId = parent.find('.experienceId').val();

          if (!emptyString(experienceId)) {
            hide = true;
            parent.html($('#editProfile #removeExperienceTemplate').html());
            parent.find('.experienceId').val(experienceId);
            parent.find('.experienceDestroy').val('1');
          } else {
            removeFromDom = true;
          }
        } else if(isEducationContainer) {
          var educationId = parent.find('.educationId').val();
          if (!emptyString(educationId)) {
            parent.html($('#editProfile #removeEducationTemplate').html());
            parent.find('.educationId').val(educationId);
            parent.find('.educationDestroy').val('1');
          } else {
            removeFromDom = true;
          }
        }

        if (hide) {
          parent.addClass('removed');
          parent.hide();
        } else if (removeFromDom) {
          parent.remove();
        }

        // Re-attach datepicker to experience or education date fields.
        // Without doing this assuming that 2 experiences are there and one is
        // removed, the remaning one's' date fields has datepicker attached
        // however it doesn't respond to navigation between months.And console
        // shows following error:
        // uncaught exception: Missing instance data for this datepicker
        if (isWorkExperienceContainer) {
          updateExistingExperienceContainersDateFieldsIdAttrVal();
          attachDatepicker($(getExperienceDateFieldSelector()), getProfessionalProfileDisplayDateFormat());
        } else if(isEducationContainer) {
          updateExistingEducationContainersDateFieldsIdAttrVal();
          attachDatepicker($(getEducationDateFieldSelector()), getProfessionalProfileDisplayDateFormat());
        }
      });
    };

    updateDateFieldsIdAttrVal = function(dateFieldContainerObject, idPrefix, containerIndex) {
      dateFieldContainerObject.find('.datepicker').each(function(index) {
        var idAttrVal = idPrefix + '_' + containerIndex + '_' + index
        $(this).attr('id', idAttrVal);
      });
    };

    updateExistingExperienceContainersDateFieldsIdAttrVal = function() {
      var workExperienceContainerSelector = getWorkExperienceContainerSelector();
      var containerIndex = 1;
      // Existing experiences when removed are hidden.Thus filter out those
      // hidden ones when updating date fields id attribute values
      $(workExperienceContainerSelector).find('.education_row').not(".removed").each(function() {
        updateDateFieldsIdAttrVal($(this), 'experience', containerIndex);
        containerIndex++;
      });
    };

    updateExistingEducationContainersDateFieldsIdAttrVal = function() {
      var educationContainerSelector = getEducationContainerSelector();
      var containerIndex = 1;
      // Existing educations when removed are hidden.Thus filter out those
      // hidden ones when updating date fields id attribute values
      $(educationContainerSelector).find('.education_row').not(":hidden").each(function() {
        updateDateFieldsIdAttrVal($(this), 'education', containerIndex);
        containerIndex++;
      });
    };

    bindClickToAddExperienceBtn = function() {
      $(getAddExperienceBtnSelector()).click(function() {
        var workExperienceContainerSelector = getWorkExperienceContainerSelector();

        $(workExperienceContainerSelector).append($(getExperienceTemplateSelector()).html());
        // Get the appended experience container
        var appendedExperienceContainerObj = $(workExperienceContainerSelector).find('.education_row').last();
        // Update the Experience's Date Fields Id attribute value
        updateExistingExperienceContainersDateFieldsIdAttrVal();
        // Bind click event to added Experience section's Remove button
        bindClickToRemoveDetailsBtn();
        // Re-attach datepicker to visible experience sections
        attachDatepicker($(getExperienceDateFieldSelector()), getProfessionalProfileDisplayDateFormat());
      });
    };

    bindClickToAddEducationBtn = function() {
      $(getAddEducationBtnSelector()).click(function() {
        var educationContainerSelector = getEducationContainerSelector();

        $(educationContainerSelector).append($(getEducationTemplateSelector()).html());
        // Get the appended education container
        var appendedEducationContainerObj = $(educationContainerSelector).find('.education_row').last();
        // Update the Education's Date Fields Id attribute value
        updateExistingEducationContainersDateFieldsIdAttrVal();
        // Bind click event to added Education section's Remove button
        bindClickToRemoveDetailsBtn();
        // Re-attach datepicker to visible education sections
        attachDatepicker($(getEducationDateFieldSelector()), getProfessionalProfileDisplayDateFormat());
      });
    };


}) (jQuery);

// Below used statement is the shortcut for jQuery(document).ready(function() {});
jQuery(function() {

  var professionalProfileSectionSelector = '#professionalProfileSection';
  var professionalProfileSection = $(professionalProfileSectionSelector).length > 0;

  if(professionalProfileSection) {

    // Bind click event to existing saved Experience and Education sections's
    // Remove button
    bindClickToRemoveDetailsBtn();

    // Update existing Experience and Education Container's Date fields Id
    // attribute values for the Datepicker to attach to them in a correct manner.
    // Attaching a datepicker to fields with identical id attribute value
    // does not work in a correct manner.Refer following links for more details:
    // 1) http://stackoverflow.com/questions/2441061/problem-when-cloning-jquery-ui-datepicker/2527248#2527248
    // 2) http://stackoverflow.com/questions/1059107/why-does-jquery-uis-datepicker-break-with-a-dynamic-dom/1256838#1256838
    updateExistingExperienceContainersDateFieldsIdAttrVal();
    updateExistingEducationContainersDateFieldsIdAttrVal();

    // Attach datepicker to existing(already saved and displayed) Experience sections date fields.
    attachDatepicker($(getExperienceDateFieldSelector()), getProfessionalProfileDisplayDateFormat());
    // Attach datepicker to existing(already saved and displayed) Education sections date fields.
    attachDatepicker($(getEducationDateFieldSelector()), getProfessionalProfileDisplayDateFormat());

    bindClickToAddExperienceBtn();
    bindClickToAddEducationBtn();

  }

});