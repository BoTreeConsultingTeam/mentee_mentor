// Reference: http://developmentmode.wordpress.com/2011/05/09/defining-custom-functions-on-jquery/
(function($) {

   bindClickToSendOrReplyMquestLink = function(link_selector) {
      var links = $(link_selector);
      links.click(function() {
        var mquestForm = $(this).parent().siblings('.mquest_reply');
        if(mquestForm.is(':visible')) {
          var message_status = mquestForm.siblings('#message_status');
          message_status.html(''); // Reset the message status container
          message_status.hide();
          mquestForm.hide();
        } else {
          // If user rmeoves text from the text area when replying and closes
          // the text-area, then when he opens the text-area, the default
          // reply text should be visible if the text-area is opened in context
          // of a received message.
          var replyDefaultTextSpan = mquestForm.find('span.reply_default_text:hidden');
          var receivedMessage = (replyDefaultTextSpan.length > 0);
          if (receivedMessage) {
            var messageContentTextArea = mquestForm.find('#message_content');
            if (messageContentTextArea.val() == '') {
              messageContentTextArea.val(replyDefaultTextSpan.text());
            }
          }
          mquestForm.show();
        }
      });
   };

}) (jQuery);

// Below used statement is the shortcut for jQuery(document).ready(function() {});
jQuery(function() {

  var mquest_section = $('.quest_section_content_text');
  if(mquest_section.length > 0) {
    bindClickToSendOrReplyMquestLink('a.send_mquest');
    bindClickToSendOrReplyMquestLink('a.mquest_reply_link');
  }

});