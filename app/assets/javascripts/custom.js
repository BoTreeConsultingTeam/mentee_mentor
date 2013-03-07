jQuery(function() {
  $('span[id^="dialoguesListing_"] #newDialogue').live('click', function() {
    resetSelectDialoguesDropdown($(this).parent());

    var messageBoxSelector = getUserMessageBoxSelector($(this));
    var formMessageThreadIdFieldSelector = getUserMessageFormMessageThreadIdSelector($(this));
    $(formMessageThreadIdFieldSelector).val('');

    var formMessageThreadTitleFieldSelector = getUserMessageFormMessageThreadTitleSelector($(this));
    $(formMessageThreadTitleFieldSelector).show();

    clearUserMessageStatusBox($(this));

    $(messageBoxSelector).toggle();
  });

  $('span[id^="dialoguesListing_"] select#dialogues').live('change', function() {
    clearUserMessageStatusBox($(this));
    var selectedMessageThreadId = $(this).val();
    var userId = $(this).siblings("#user_id").val();
    var messageBoxSelector = getUserMessageBoxSelector($(this));
    var formMessageThreadIdFieldSelector = getUserMessageFormMessageThreadIdSelector($(this));
    if (selectedMessageThreadId == '') {
      $(formMessageThreadIdFieldSelector).val('');
      $(messageBoxSelector).hide();
      alert("Please select a dialogue");
      return false;
    } else {
      var formMessageThreadTitleFieldSelector = getUserMessageFormMessageThreadTitleSelector($(this));
      $(formMessageThreadTitleFieldSelector).hide();
      $(formMessageThreadIdFieldSelector).val(selectedMessageThreadId);

      $(messageBoxSelector).show(true);
    }
  });

  /* Carousel */
  $('#mycarousel').jcarousel({
    wrap: 'circular'
  });

  bindAnimationToUserSettingsDropdown();

  var editProfileView = $('#editProfile').length > 0;

  if(editProfileView) {
    makePersonalProfileActiveByDefault();
    bindClickToProfileSectionAndActivateSelectedProfileSection();
  }

  bindFileUploadToUserPicture();

});

function bindFileUploadToUserPicture() {
  var userPicture = $('#userPicture');
  if(userPicture.length > 0) {
    // Reference: http://code.google.com/p/ocupload/
    userPicture.upload({
      name: 'photo',
      action: $('#upload_picture_action_url').val() + '.json',
      params: {
        "authenticity_token": $('meta[name="csrf-token"]').attr('content')
      },
      onComplete: function(response) {
        userPicture.attr('src', response);
      }
    });
  }
}

function makePersonalProfileActiveByDefault() {
  var profileMenuItemSelector = '#sidenav .profileMenuItem';
  var anyProfileMenuItemActive = $(profileMenuItemSelector).hasClass('active');

  if(!anyProfileMenuItemActive) {
    // By default keep active the Personal Profile section
    $(profileMenuItemSelector).first().addClass('active');
    // Hide the Professional Section when Personal Profile
    toggleProfessionalProfile(false);
  }
}

function bindClickToProfileSectionAndActivateSelectedProfileSection() {
  $('#sidenav .profileMenuItem').live('click', function() {
    $(this).addClass('active');
    $(this).parent().siblings().find('.profileMenuItem').removeClass('active');
    var activeProfileSection = $(this).attr('rel');

    switch(activeProfileSection) {
      case 'personalProfileLink':
        togglePersonalProfile(true);
        toggleProfessionalProfile(false);
        toggleAffiliationsProfile(false);
        break;

      case 'professionalProfileLink':
        togglePersonalProfile(false);
        toggleProfessionalProfile(true);
        toggleAffiliationsProfile(false);
        break;

      case 'affiliationsProfileLink':
        togglePersonalProfile(false);
        toggleProfessionalProfile(false);
        toggleAffiliationsProfile(true);
        break;
    }
  });
}

function toggleProfileSection(section, flag) {
  var sectionSelector = '';
  switch(section) {
    case 'personal':
      sectionSelector = '#personalProfileSection';
      break;

    case 'professional':
      sectionSelector = '#professionalProfileSection';
      break;

    case 'affiliations':
      sectionSelector = '#affiliationsProfileSection';
      break;
  }

  if(sectionSelector != '') {
    var sectionObj =  $(sectionSelector);
    if(sectionObj.length > 0) {
      if(flag) {
        sectionObj.show();
      } else {
        sectionObj.hide();
      }
    }
  }
}

function togglePersonalProfile(flag) {
  toggleProfileSection('personal', flag);
}

function toggleProfessionalProfile(flag) {
  toggleProfileSection('professional', flag);
}

function toggleAffiliationsProfile(flag) {
  toggleProfileSection('affiliations', flag);
}

function bindAnimationToUserSettingsDropdown() {
  var dashboardPageHeaderContainerSelector = ".content_bg_dashboard_rgt";

  var dashboardPageSettingsContainerSelector = ".setting_drop";
  var dashboardPageSettingsDropdownObj = $(dashboardPageHeaderContainerSelector).find(dashboardPageSettingsContainerSelector);
  if (dashboardPageSettingsDropdownObj.length > 0) {
    var dashboardPageSettingsListingObj = $(dashboardPageHeaderContainerSelector).find('.setting_listing');

    // Reference: http://stackoverflow.com/questions/4629774/hide-div-on-blur
    // On the click on the Settings image the Settings dropdown should be toggled
    dashboardPageSettingsDropdownObj.click(function(event) {
      dashboardPageSettingsListingObj.slideToggle();
      event.stopPropagation();
    });

    // On the body click the the Settings dropdown should be hidden
    $(document.body).click(function() {
       dashboardPageSettingsListingObj.hide();
    });

    // On the click on the Settings image and the items in Settings dropdown,
    // the event should not be propagated to the body
    dashboardPageSettingsListingObj.click(function(event) {
       event.stopPropagation();
    });

  }
}

function getUserMessageBoxSelector(obj) {
  var userId = obj.siblings("#user_id").val();
  var messageBoxSelector = "#messageBox_" + userId;
  return messageBoxSelector;
}

function getUserMessageFormSelector(obj) {
  var messageBoxSelector = getUserMessageBoxSelector(obj);
  var messageFormSelector = messageBoxSelector + " form";
  return messageFormSelector;
}

function getUserMessageFormMessageThreadIdSelector(obj) {
  return getUserMessageFormSelector(obj) + " #messageThreadId";
}

function getUserMessageFormMessageThreadTitleSelector(obj) {
  return getUserMessageFormSelector(obj) + " #message_thread_title";
}

function clearUserMessageStatusBox(obj) {
  var messageBoxSelector = getUserMessageBoxSelector(obj);
  $(messageBoxSelector).siblings('#messageStatusBox').find('span:first').html('');
}

function resetSelectDialoguesDropdown(containerSelector) {
  // Reset Select Dialogue option, if select box is present.
  var dialogueSelect = $(containerSelector).find('select#dialogues');
  if (dialogueSelect.length > 0) {
    dialogueSelect.find('option:first').attr('selected', 'selected');
  }
}

function emptyString(string) {
  if((string == undefined) || (string == null) || ($.trim(string) == '') ) {
    return true;
  }

  return false;
}

function attachDatepicker(selector, dateFormat) {
  if(emptyString(dateFormat)) {
    dateFormat = 'dd-mm-yy'
  }

  // Remove datepicker first - datepicker doesn't work correctly
  // on dynamically added/removed fields if this is not done.
  // Refer this link for the problem faced:
  // 1) http://stackoverflow.com/questions/12093030/datepicker-on-dynamically-created-row-with-inputs
  $(selector).removeClass('hasDatepicker');

  // Attach datepicker
  $(selector).datepicker({
    dateFormat: dateFormat,
    changeMonth: true,
    changeYear: true
  });

};