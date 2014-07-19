module HashtagsHelper
  def make_link_to_hashtag(content)
    if(!content[Hashtag.get_regex].nil?)
      content.gsub(Hashtag.get_regex) do |t|
        tag=Hashtag.find_by(text: t[1..-1].downcase);
        if(!tag.nil?)
          link_to(t , hashtag_path(Hashtag.find_by(text: t[1..-1].downcase  ) ));
        else
          t
        end
      end
    else
      content;
    end
  end
end
