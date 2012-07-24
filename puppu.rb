# -*- coding: utf-8 -*-
class PuppuPlugin < Plugin
  require 'net/http'
  require 'iconv'
  def help(plugin, topic="")
    "puppu => gives a puppulause from puppulausegeneraattori.fi requires topic for puppulause;
  'yleinen','tietotekniikka','politiikka','talous','yritysmaailma','oikeustiede','opiskelijaelämä','monikulttuurisuus' or any other word"
  end



  def puppu(m,params)
    sana = params[:hakusana]
    valmiinaolevat = ['yleinen','tietotekniikka','politiikka','talous','yritysmaailma','oikeustiede','opiskelijaelämä','monikulttuurisuus']
    kysely = "" if sana
    if valmiinaolevat.include? sana
      kysely='?a='+valmiinaolevat.index(sana).to_s
    elsif sana
      kysely="?avainsana=#{sana}"
    end

    http_response = Net::HTTP.get_response URI.parse "http://puppulausegeneraattori.fi/#{kysely}"
    http_response = http_response.body.slice!(http_response.body.index("<P CLASS=\"lause\""),http_response.body.length)
    message =  http_response.slice!(17, http_response.index("</P>")-17)
    ## if using 1.8.7 uncomment below
    m.reply Iconv.conv("UTF8", "LATIN1", message)
    ##If using ruby 1.9.3 uncomment below
    #m.reply message.force_encoding('iso-8859-1').encode! 'UTF-8'
  end
end

plugin = PuppuPlugin.new
plugin.map 'puppu :hakusana'#, :defaults => {:hakusana => 'tietotekniikka'}
