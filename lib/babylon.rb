module Babylon
  require 'rubygems'
  require 'httparty'
  include HTTParty
  
  class Error < ArgumentError; end;

  class UncertaintyError < StandardError; end;

  VERSION = '0.1.1'

  SERVICE_URL = 'http://www.google.com/uds/GlangDetect'
  format :json

  LANGUAGES = {
    'af' => :afrikaans,
    'sq' => :albanian,
    'am' => :amharic,
    'ar' => :arabic,
    'hy' => :armenian,
    'az' => :azerbaijani,
    'eu' => :basque,
    'be' => :belarusian,
    'bn' => :bengali,
    'bh' => :bihari,
    'bg' => :bulgarian,
    'my' => :burmese,
    'ca' => :catalan,
    'chr' => :cherokee,
    'zh' => :chinese,
    'zh-CN' => :chinese_simplified,
    'zh-TW' => :chinese_traditional,
    'hr' => :croatian,
    'cs' => :czech,
    'da' => :danish,
    'dv' => :dhivehi,
    'nl' => :dutch,
    'en' => :english,
    'eo' => :esperanto,
    'et' => :estonian,
    'tl' => :filipino,
    'fi' => :finnish,
    'fr' => :french,
    'gl' => :galician,
    'ka' => :georgian,
    'de' => :german,
    'el' => :greek,
    'gn' => :guarani,
    'gu' => :gujarati,
    'iw' => :hebrew,
    'hi' => :hindi,
    'hu' => :hungarian,
    'is' => :icelandic,
    'id' => :indonesian,
    'iu' => :inuktitut,
    'it' => :italian,
    'ja' => :japanese,
    'kn' => :kannada,
    'kk' => :kazakh,
    'km' => :khmer,
    'ko' => :korean,
    'ku' => :kurdish,
    'ky' => :kyrgyz,
    'lo' => :laothian,
    'lv' => :latvian,
    'lt' => :lithuanian,
    'mk' => :macedonian,
    'ms' => :malay,
    'ml' => :malayalam,
    'mt' => :maltese,
    'mr' => :marathi,
    'mn' => :mongolian,
    'ne' => :nepali,
    'no' => :norwegian,
    'or' => :oriya,
    'ps' => :pashto,
    'fa' => :persian,
    'pl' => :polish,
    'pt-PT' => :portuguese,
    'pa' => :punjabi,
    'ro' => :romanian,
    'ru' => :russian,
    'sa' => :sanskrit,
    'sr' => :serbian,
    'sd' => :sindhi,
    'si' => :sinhalese,
    'sk' => :slovak,
    'sl' => :slovenian,
    'es' => :spanish,
    'sw' => :swahili,
    'sv' => :swedish,
    'tg' => :tajik,
    'ta' => :tamil,
    'tl' => :tagalog,
    'te' => :telugu,
    'th' => :thai,
    'bo' => :tibetan,
    'tr' => :turkish,
    'uk' => :ukrainian,
    'ur' => :urdu,
    'uz' => :uzbek,
    'ug' => :uighur,
    'vi' => :vietnamese,
    '' => :unknown
  }
  
  #
  # Determines the language of a string
  #
  # options: An options hash which can take two options:
  #
  #   :min_certainty: Google tells us how certain it is with it's decission of 
  #                   what language the content is. If you want to avoid wild 
  #                   guesses you can set the min_certainty to a level and if
  #                   the resulting certainty is below this threshold an 
  #                   Babylon::UncertaintyError is raised.
  #                   Tip: For shorter strings 0.2 seems to mean a good result.
  #                     For medium long strings 0.6 is ok and for any text more
  #                     than 150 words or so google tends to be really confident 
  #                     about what it does which leads to a certainty around 0.9
  #
  #   :ensure_reliability: In addition to the raw certainty value Google 
  #                        delivers a boolean value in the result set to let us
  #                        know if it thinks the result is reliable or not.
  #                        If you set this option to true an 
  #                        Babylon::UncertaintyError is raised unless Google
  #                        think the result is reliable.
  #
  #   Babylon.language_of('¿Dónde está el baño?') #=> :spanish
  #   Babylon.language_of('sgffdg sfdjkhsdfkh') #=> :english
  #   Babylon.language_of('sgffdg sfdjkhsdfkh', :min_certainty => 0.1) #=> raises Babylon::UncertaintyError
  #   Babylon.language_of('sgffdg sfdjkhsdfkh', :ensure_reliability => true) #=> raises Babylon::UncertaintyError
  def self.language_of(content, options = {})
    min_certainty = options[:min_certainty] || 0.0
    ensure_reliability = options[:ensure_reliability]

    result = self.raw_language_query(content)

    certainty = result['responseData']['confidence']
    reliable  = result['responseData']['isReliable']
    raise UncertaintyError if certainty < min_certainty || (ensure_reliability && !reliable)

    LANGUAGES[result['responseData']['language']];
  end

  # Method to get the raw result Google sends us.
  #
  #   Babylon.raw_language_query('¿Dónde está el baño?') => {"responseData"=>{"language"=>"es", "confidence"=>0.24530953, "isReliable"=>true}, "responseStatus"=>200, "responseDetails"=>nil
  def self.raw_language_query(content)
    result = get(SERVICE_URL, :query => {:v => 1.0, :q => content})
    
    raise Error.new('Bad response from Google!') unless result['responseStatus'] == 200
    result
  end
end
