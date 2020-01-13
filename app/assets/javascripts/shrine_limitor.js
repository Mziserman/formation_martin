$(document).ready(function () {
  let $container = $('.has_many_container.thumbnail');
  let $add_button = $container.find('a.button.has_many_add');

  $add_button.click((_) => {
    $add_button.hide();
    $.when($container.find('a.button.has_many_remove')).then((_) => {
      $container.find('a.button.has_many_remove').click((_) => {
        $add_button.show();
      })
    });
  })
})
