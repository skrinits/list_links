$(function() {
  var $links = $('.js-create-links');

  $links.submit(function(event) {
    event.preventDefault();

    var $submitButton = $links.find(':submit');
    var $message = $links.find('.message')

    $submitButton.attr('disabled', true);

    $.ajax({
      url: $links.attr('action'),
      method: $links.attr('method'),
      data: JSON.stringify({ links: $links.serializeFormJSON()['links'].trim().split(/\s+/) }),
      contentType: 'application/json',
      dataType: 'json',
      success: function(data, status, xhr) {
        if(data.errors) {
          $message.html(data.errors.join("\n"));
        } else {
          $message.html('Обработано');
        }

        $links.find('textarea').val('');
        $submitButton.attr('disabled', false);
      },
      error: function(xhr, status, error) {
        $links.find('.message').html(error)
        $submitButton.attr('disabled', false);
      }
    })
  });
});
