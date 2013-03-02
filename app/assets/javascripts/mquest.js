// Reference: http://developmentmode.wordpress.com/2011/05/09/defining-custom-functions-on-jquery/
(function($) {

   bindClickToSendOrReplyMquestLink = function(link_selector) {
      var links = $(link_selector);
      links.click(function() {
        var mquestForm = $(this).parent().siblings('.mquest_reply');
        var mquestFormVisible = mquestForm.is(':visible');

        if(mquestFormVisible) {
          var message_status = mquestForm.siblings('#message_status');
          message_status.html(''); // Reset the message status container
          message_status.hide();
          mquestForm.hide();
          mquestFormVisible = false;
        } else {
          mquestForm.show();
          mquestFormVisible = true;
        }

        // For handling styling of displayed messages of a thread on MQuests page
        var mquestPageMessagesHolderContainer = mquestForm.siblings(".quest_poster-thumbs-content");
        if (mquestPageMessagesHolderContainer.length > 0) {
          if(mquestFormVisible) {
            mquestPageMessagesHolderContainer.attr('style', 'padding-left: 180px; padding-top: 10px');
          } else {
            mquestPageMessagesHolderContainer.attr('style', '');
          }
        }

        // For handling styling of displayed messages of a thread on Dashboard
        // page's Timeline section
        var dashboardPageMessagesHolderContainer = mquestForm.siblings(".time_line_txt");
        if (dashboardPageMessagesHolderContainer.length > 0) {
          if(mquestFormVisible) {
            dashboardPageMessagesHolderContainer.attr('style', 'padding-left: 192px; padding-top: 25px');
          } else {
            dashboardPageMessagesHolderContainer.attr('style', '');
          }
        }

      });
   };

}) (jQuery);

// Below used statement is the shortcut for jQuery(document).ready(function() {});
jQuery(function() {

  var mquest_section = $('.quest_section_content_text');
  if( mquest_section.length > 0 ) {
    bindClickToSendOrReplyMquestLink('a.send_mquest');
    bindClickToSendOrReplyMquestLink('a.mquest_reply_link');
  }

});