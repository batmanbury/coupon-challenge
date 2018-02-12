//= require jquery-ui

$(document).on('coupons#new:loaded', function() { prepareAutocomplete(); });

// Autocomplete for brand selection
function prepareAutocomplete() {
  if (!!$('#brand_select').length) {
    // Fix autocomplete list item width
    $.ui.autocomplete.prototype._resizeMenu = function () {
      var ul = this.menu.element;
      ul.outerWidth(this.element.outerWidth());
    }

    $('#brand_select').autocomplete({
      minLength: 2,
      messages: {
        noResults: '',
        results: function() {},
      },
      source: $('#brand_select').data('path'),
      focus: function(event, ui) {
        $('#brand_select').val(ui.item.label);
        $(".ui-helper-hidden-accessible").hide();
        return false;
      },
      // Upon selection, do:
      select: function(event, ui) {
        $('#brand_select').val(ui.item.label);
        $('#coupon_brand_id').val(ui.item.value);
        return false;
      }
    })
    .data("uiAutocomplete")._renderItem = function(ul, item) {
      // Display the brand name (only inline styles are working here)
      return $("<li style='list-style: none; font-size: 20px; padding: 5px; margin-left: -42px; background: white; text-decoration: none; border: 1px solid #ced4da; border-top: none;'></li>")
      .data("item.autocomplete", item.label)
      .append("<a>" + item.label + "</a>")
      .appendTo(ul);
    };
  }
}
