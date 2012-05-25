require 'formatador'
require 'htmlentities'

class Google
  def display_serp info
    results           = info[:results]
    query_strings     = info[:query_strings]
    coder             = HTMLEntities.new
    current_page      = results['responseData']['cursor']['currentPageIndex']+1
    max_result        = query_strings[:start] + query_strings[:rsz]
    estimated_results = results['responseData']['cursor']['resultCount']
    result_array      = results['responseData']['results']

    attribution  = "\n"
    attribution << ' ' * (max_result.to_s.length + 2)
    attribution << "[yellow]Powered by Google[/]"
    Formatador.display_line attribution

    result_array.each_with_index do | result, i |
      this_num = (i + query_strings[:start] + 1).to_s

      serp_title  = "\n#{' ' * (max_result.to_s.length - this_num.length)}"
      serp_title << "[bold][blue]#{this_num}. "
      serp_title << "[normal]#{result["titleNoFormatting"]}[/]\n"
      serp_url    = ' ' * max_result.to_s.length
      serp_url   << "[green]#{result["url"]}[/]\n"
      serp_desc   = ' ' * max_result.to_s.length
      serp_desc  << result["content"].gsub(/<b>/, "[bold]")
                    .gsub(/<\/b>/, "[/]").squeeze(" ")

      Formatador.display_line coder.decode(
        Utils::wrap(serp_title, :prefix => max_result.to_s.length + 2)
      )
      Formatador.display_line coder.decode(
        Utils::wrap(serp_url, :prefix => max_result.to_s.length + 2)
      )
      Formatador.display_line coder.decode(
        Utils::wrap(serp_desc, :prefix => max_result.to_s.length + 2)
      )
    end

    metadata  = ''
    metadata << "\n#{' ' * (max_result.to_s.length + 2)}"
    metadata << "[yellow]Displaying results "
    metadata << "#{query_strings[:start] + 1} through "
    metadata << "#{max_result} of "
    metadata << "#{estimated_results} "
    metadata << "(Page #{current_page})"
    Formatador.display_line metadata

    input info, result_array
  end
end