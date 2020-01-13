function setThumbnailEvents(container) {
  let $remove_thumbnail_button = container.find('.remove_thumbnail');
  let $thumbnail_data = container.find('input#project_thumbnail_data');
  let $display = container.find('.inline-hints img');

  $remove_thumbnail_button.click((e) => {
    e.preventDefault();
    $thumbnail_data.val('');
    $display.hide();
    $remove_thumbnail_button.hide();
  });
}

function setLandscapeEvents(container) {
  let $remove_landscape_button = container.find('.remove_landscape');
  let $landscape_data = container.find('input#project_landscape_data');
  let $display = container.find('.inline-hints img');

  $remove_landscape_button.click((e) => {
    e.preventDefault();
    $landscape_data.val('');
    $display.hide();
    $remove_landscape_button.hide();
  });
}

$(document).ready(function () {
  let $projectFromContainer = $('#edit_project');
  setThumbnailEvents($projectFromContainer);
  setLandscapeEvents($projectFromContainer);
});
