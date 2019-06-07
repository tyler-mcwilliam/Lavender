import "bootstrap";
import "mainchart";

$(document).on("click", ".join-group-button", function () {
     const groupId = $(this).data('id');
     $(".modal-body #user_group_group_id").val( groupId );
});
