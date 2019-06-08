// // app/assets/javascripts/chatrooms.coffee

// $(document).ready(() => {});
// const popupWrapper = $('.popup-wrapper');
// const popupTrigger = $('.popup-trigger');
// // open the live chat widget if clicked
// $('.popup-head').click(function() {
//   popupWrapper.addClass('collapse');
//   popupTrigger.removeClass('collapse');
// });

// // close the live chat widget if clicked
// $('.popup-trigger').click(function() {
//   popupWrapper.removeClass('collapse');
//   popupTrigger.addClass('collapse');
// });

// // if the user's name and email is successfully submitted, hide the form and show the chat interface in the widget
// $('#start-chat-form').on('ajax:success', function(data) {
//   const chatroom = data.detail[0];
//   $('.chat-form').removeClass('collapse');
//   $('.start-chat-wrapper').addClass('collapse');
//   $('.chat-wrapper').removeClass('collapse');
//   $('#chat-form #name').val(chatroom.name);
//   $('#chat-form #chatroom_id').val(chatroom.id);
//   getChats(chatroom.id);
//   $('#start-chat-form')[0].reset();
// });
// var getChats = function(id) {
//   const token = $('meta[name="csrf-token"]').attr('content');
//   $.ajax({
//     url: `chatrooms/${id}`,
//     type: 'get',
//     beforeSend(xhr) {
//       xhr.setRequestHeader('X-CSRF-Token', token);
//     },
//     success(data) {
//     }
//   });
// };

// // update the user's chat with new chat messages
// const updateChat = function(data) {
//   if (data.chatroom_id === parseInt($('input#chatroom_id').val())) {
//     $('.chats').append(`\
// <div class="chat-bubble-wrapper d-block">
//   <div class="chat-bubble bg-dark p-1 text-white my-1 d-inline-block">
//     <small class="chat-username">${data.name}</small>
//     <p class="m-0 chat-message">${data.message}</p>
//   </div>
// </div>\
// `
//     );
//   }
// };

// // if the user's chat message is successfully sent, reset the chat input field
// $('#chat-form').on('ajax:success', function(data) {
//   const chat = data.detail[0];
//   $('#chat-form')[0].reset();
// });

// // function for displaying chat messages that belong to chat selcted in the admin sidebar
// const loadAdminChat = function(chatArray) {
//   $('.admin-chats').html("");
//   $('input#chatroom_id').val(chatArray.chats[0].chatroom_id);
//   $.map(chatArray.chats, function(chat) {
//     $('.admin-chats').append(`\
// <div class="chat-bubble-wrapper d-block">
//   <div class="chat-bubble bg-dark p-1 text-white my-1 d-inline-block" style="min-width: 10rem;">
//     <small class="chat-username">${chat.name}</small>
//     <p class="m-0 chat-message">${chat.message}</p>
//   </div>
// </div>\
// `
//     );
//   });
// };

// // if the available chat in the sidebar is clicked, call the function that displays it's messages
// $('body').on('ajax:success', '.sidebar-chat', function(data) {
//   const chat = data.detail[0];
//   loadAdminChat(chat);
// });

// // function to update admin's chat with new chat messages
// const updateAdminChat = function(chat) {
//   if (chat.chatroom_id === parseInt($('input#chatroom_id').val())) {
//     $('.admin-chats').append(`\
// <div class="chat-bubble-wrapper d-block">
//   <div class="chat-bubble bg-dark p-1 text-white my-1 d-inline-block" style="min-width: 10rem;">
//     <small class="chat-username">${chat.name}</small>
//     <p class="m-0 chat-message">${chat.message}</p>
//   </div>
// </div>\
// `
//     );
//   }
// };

// // function to update the available chats in the sidebar
// const updateAdminChatrooms = function(chatroom) {
//   $('.sidebar').append(`\
// <div class="dashboard-sidebar-chat bg-info">
//   <a class="sidebar-chat" data-remote="true" href="/chats/${chatroom.id}">${chatroom.email}</a>
// </div>\
// `
//   );
// };
// // if admin's chat is successfully  sent, clear the chat input field
// $('#admin-chat-form').on('ajax:success', function(data) {
//   const chat = data.detail[0];
//   $('#admin-chat-form')[0].reset();
// });
