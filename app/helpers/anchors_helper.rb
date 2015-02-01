module AnchorsHelper
  def section_anchor(anchor_name)
    content_tag(:a, '', class: 'section-anchor', name: anchor_name)
  end
end
