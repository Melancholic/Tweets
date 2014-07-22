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

  def most_common_value(a)
  puts "\n\n\n ARG: #{a}"
    res={};
    unless a.any?
      res[:size]=0;
      res[:value]='none';
    else       
      ar = a.group_by{|i| i}.values.max_by(&:size);
      res[:size]=ar.size;
      res[:value]=ar.first;
    end
    return res;
  end

  def most_rare_value(a)
    res={};
     unless a.any?
      res[:size]=0;
      res[:value]='none';
    else 
      ar=a.group_by{|i| i}.values.min_by(&:size);
      res[:size]=ar.size;
      res[:value]=ar.first;
    end
    return res;
  end
end
