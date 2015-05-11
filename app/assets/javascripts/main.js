$(document).ready(ready);
$(document).on('page:load', ready);

function ready() {
  loadNewEngraving();
  loadUI();
}

function loadNewEngraving() {
  var $container = $('.engraving-score').first();
  if ($container.data('engraving-state') == 'new') {
    function updateEngraving() {
      var id = $container.data('engraving-id'),
          $img = '<img src=' + engravingUrl(id) + ' alt="engraving ' + id + '" class="img-responsive" />';
      setTimeout(function() {
        $.getJSON('/engravings/' + id, function(response) {
          if (response.state == 'new') {
            updateEngraving();
          } else if (response.state == "completed") {
            $container.empty().append($img);
          } else if (response.state = "error") {
            var $errorMsg = '<h4>Something\'s wrong with your code.</h4><ul class="error-list">',
                errorJSON = $.parseJSON(response.error);
            $.each(errorJSON, function(i, error) {
              $errorMsg += '<li>line' + error.line + ': ' + error.msg + '</li>';
            });
            $errorMsg += '</ul>';
            $container.empty().append($errorMsg);
          }
        })
      }, 5000);
    }
    updateEngraving();
  }
}

function engravingUrl(id) {
  var env = currentEnv();
  if (env == "development") {
    return '/images/engravings/' + id + '.png';
  } else if (env == "production") {
    return 'https://engravings.s3-eu-central-1.amazonaws.com/' + id + '.png';
  }
}

// UI.

function loadUI() {
  setHeaderLink();
  switch (currentPage()) {
    case 'New Engraving':
      loadPrivateCheckbox();
      loadInputEditor();
      break;
    case 'Guide':
      loadGuideAffix();
      loadGuideExamples();
      break;
    case 'Browse':
      loadEngravingToggleLinks();
      loadEngravingsCode();
      break;
  }
  if (/#(\d|-|[a-z]){36}/.test(currentPage())) {
    loadEngravingToggleLinks();
    loadEngravingsCode();
  }
}

function setHeaderLink() {
  $('nav.header-links').find('a').removeClass('active');
  switch (currentPage()) {
    case 'New Engraving':
      $('#header-link-create').addClass('active');
      break;
    case 'Guide':
      $('#header-link-guide').addClass('active');
      break;
    case 'About':
      $('#header-link-about').addClass('active');
      break;
    default:
      $('#header-link-browse').addClass('active');
  }
}

function loadPrivateCheckbox() {
  var checkbox = $('.btn-checkbox'),
      hiddenCheckbox = $('#engraving_is_private');
  if (hiddenCheckbox.is(':checked')) {
    checkbox.addClass('checked');
  } else {
    checkbox.removeClass('checked');
  }
  checkbox.on('click', function() {
    $(this).toggleClass('checked');
    if (hiddenCheckbox.is(':checked')) {
      hiddenCheckbox.prop('checked', false);
    } else {
      hiddenCheckbox.prop('checked', true);
    }
  });
}

function loadEngravingToggleLinks() {
  $('.toggle-code').on('click', function(e) {
    e.preventDefault();
    $(this).closest('.engraving-container').find('.engraving-code').slideToggle(200);
  });
  $('.toggle-share').on('click', function(e) {
    e.preventDefault();
    $(this).closest('.engraving-container').find('.engraving-share').slideToggle(200);
  });
  $('.glyphicon-remove').on('click', function() {
    $(this).closest('.engraving-container').find('.engraving-code').slideToggle(200);
  })
}

// Ace loaders.

function newAceEditor(id) {
  var editor = ace.edit(id);
  editor.getSession().setMode("ace/mode/lilypond");
  editor.getSession().setTabSize(2);
  editor.getSession().setUseSoftTabs(true);
  editor.setHighlightActiveLine(true);
  editor.setTheme("ace/theme/tomorrow_night_eighties");
  editor.setShowPrintMargin(false);
  editor.getSession().setUseWrapMode(true);
  editor.setReadOnly(true);
  editor.setFontSize(aceFontSize());
  return editor;
}

function aceFontSize() {
  if ($(document).width() > 992) {
    return 12;
  } else {
    return 16;
  }
}

function loadInputEditor() {
  var lilyInput = newAceEditor("ace-new-engraving");
  lilyInput.setReadOnly(false);

  // First, on page load Ace should get code from current engraving.
  lilyInput.getSession().setValue($('.form-hidden').text());
  lilyInput.gotoPageDown();
  lilyInput.focus();

  // Then the engraving textarea begins listening to Ace.
  lilyInput.on("blur", function() {
    var input = lilyInput.getSession().getValue();
    $('.form-hidden').text(input);
  });
}

function loadEngravingsCode() {
  var engravings = $(document).find('.engraving-ace'),
      editor,
      id,
      code;
  $.each(engravings, function(i, v) {
    id = $(this).attr('id');
    code = $(this).prev('pre').text();
    editor = newAceEditor(id);
    editor.getSession().setValue(code);
    editor.setHighlightActiveLine(false);
    adjustAceHeight(id, editor.session.getLength());
  })
}

function loadGuideExamples() {
  var examples = $(document).find('.guide-example-code'),
      example,
      id;
  $.each(examples, function(i) {
    id = 'example' + i;
    $(this).attr('id', id);
    example = newAceEditor(id);
    example.setHighlightActiveLine(false);
    example.resize();
    adjustAceHeight(id, example.session.getLength());
  });
}

function adjustAceHeight(id, lines) {
  $('#' + id).css('height', Math.floor(lines * aceFontSize() * 1.34) + 'px');
}

// Guide affix behavior.

function loadGuideAffix() {
  var affixFixed = false;
  $(document).scroll(function() {
    if ($(this).scrollTop() >= 116) {
      if (!affixFixed) {
        affixFixed = true;
        $('.sidenav').css({position: 'fixed', top: 0});
      }
    } else {
      if (affixFixed) {
        affixFixed = false;
        $('.sidenav').css({position: 'static'});
      }
    }
  });
}

// Helpers to determine current page and environment.

function currentEnv() {
  return $('body').data('env');
}

function currentPage() {
  return $('body').data('content');
}
