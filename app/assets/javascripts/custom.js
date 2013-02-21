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
  /* slider */
  jQuery('#mycarousel').jcarousel({
    wrap: 'circular'
  });
});

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
