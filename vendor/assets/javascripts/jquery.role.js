/*
 * Add `@data-role` alias to jQuery.
 *
 * Copy from jquery.role by Sasha Koss https://github.com/kossnocorp/role
 */

!function($){
  var rewriteSelector = function (context, name, pos) {
      var original = context[name];
      if ( !original ) {
          return;
      }

      context[name] = function () {
          arguments[pos] = arguments[pos].replace(
              /@([\w\u00c0-\uFFFF\-]+)/g, '[data-role~="$1"]');
          return original.apply(context, arguments);
      };

      $.extend(context[name], original);
  };

  rewriteSelector($, 'find', 0);
  rewriteSelector($, 'multiFilter', 0);
  rewriteSelector($.find, 'matchesSelector', 1);
  rewriteSelector($.find, 'matches', 0);
}(jQuery)
