function setShrineEvents(container, type) {
  let $remove_image_button = container.find(`.remove_${type}`);
  let $image_data = container.find(`input#project_${type}_data`);
  let $display = container.find('.inline-hints img');

  $remove_image_button.click((e) => {
    e.preventDefault();
    $image_data.val('');
    $display.hide();
    $remove_image_button.hide();
  });
}

$(document).ready(function () {
  let $projectFromContainer = $('#edit_project');
  setShrineEvents($projectFromContainer, 'thumbnail');
  setShrineEvents($projectFromContainer, 'landscape');
});
