module MicropostsHelper
  def wrap(content)
    sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
  end

private
  def wrap_long_string(text, max_width=30)
    end_lines="&#8203;";
    regex=/.{1,#{max_width}}/;
    (text.length<max_width) ? text:text.scan(regex).join(end_lines);
  end

end
