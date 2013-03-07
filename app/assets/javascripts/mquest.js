// Reference: http://developmentmode.wordpress.com/2011/05/09/defining-custom-functions-on-jquery/
(function($) {

   bindClickToSendOrReplyMquestLink = function(link_selector) {
      var links = $(link_selector);
      links.click(function() {
        var linkTitleAttr = $(this).attr('title');
        var mquestForm = $(this).parent().siblings('.mquest_reply');
        var mquestFormVisible = mquestForm.is(':visible');

        if(mquestFormVisible) {
          // Reset the text area for writing message
          mquestForm.find("form #message_content").val('');

          var message_status = mquestForm.siblings('#message_status');
          message_status.html(''); // Reset the message status container
          message_status.hide();
          mquestForm.hide();
          mquestFormVisible = false;
          $(this).text(linkTitleAttr);
        } else {
          mquestForm.show();
          mquestFormVisible = true;
          $(this).text('Cancel');
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

      });
   };

}) (jQuery);

// Below used statement is the shortcut for jQuery(document).ready(function() {});
jQuery(function() {
  var search_results_section = $('.section_content_text_search');
  var mquest_section = $('.quest_section_content_text');
  if( (search_results_section.length > 0) || (mquest_section.length > 0) ) {
    bindClickToSendOrReplyMquestLink('a.send_mquest');
    bindClickToSendOrReplyMquestLink('a.mquest_reply_link');
  }

});