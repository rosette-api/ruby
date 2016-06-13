# encoding: UTF-8
require 'rosette_api'
require 'rspec'
require 'webmock/rspec'
require 'json'
WebMock.disable_net_connect!(allow_localhost: true)

describe RosetteAPI do

  describe '.get_language' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/language.json'))
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/language').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'language'}.to_json, headers: {})
    end
    it 'test language' do
      params = DocumentParameters.new
      params.content = 'Por favor Senorita, says the man.?'
      response = RosetteAPI.new('0123456789').get_language(params)
      expect(response).instance_of? Hash
    end

    it 'badRequestFormat: the format of the request is invalid: multiple content sources' do
      params = DocumentParameters.new
      params.content = 'Por favor Senorita, says the man.?'
      params.content_uri = 'Por favor Senorita, says the man.?'
      expect { RosetteAPI.new('0123456789').get_language(params) }.to raise_error(BadRequestFormatError)
    end

    it 'badRequestFormat: the format of the request is invalid: no content provided;' do
      params = DocumentParameters.new
      expect { RosetteAPI.new('0123456789')
                         .get_language(params) }
                         .to raise_error(BadRequestFormatError)
    end

  end

  describe '.get_morphology_complete' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/morphology_complete.json'))
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/morphology/complete').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'morphology/complete'}.to_json, headers: {})
    end
    it 'test morphology complete' do
      params = DocumentParameters.new
      params.content = 'The quick brown fox jumped over the lazy dog. Yes he did.'
      response = RosetteAPI.new('0123456789').get_morphology_complete(params)
      expect(response).instance_of? Hash
    end
  end

  describe '.get_compound_components' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/morphology_compound_components.json'))
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/morphology/compound-components').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'morphology/compound-components'}.to_json, headers: {})
    end
    it 'test morphology compound components' do
      params = DocumentParameters.new
      params.content = 'Rechtsschutzversicherungsgesellschaften'
      response = RosetteAPI.new('0123456789').get_compound_components(params)
      expect(response).instance_of? Hash
    end
  end

  describe '.get_han_readings' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/morphology_han_readings.json')), encoding: 'utf-8'
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/morphology/han-readings').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'morphology/han-readings'}.to_json, headers: {})
    end
    it 'test morphology han readings' do
      params = DocumentParameters.new
      params.content = '北京大学生物系主任办公室内部会议'
      response = RosetteAPI.new('0123456789').get_han_readings(params)
      expect(response).instance_of? Hash
    end
  end

  describe '.get_parts_of_speech' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/morphology_parts_of_speech.json'))
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/morphology/parts-of-speech').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'morphology/parts-of-speech'}.to_json, headers: {})
    end
    it 'test morphology parts of speech' do
      params = DocumentParameters.new
      params.content = "The fact is that the geese just went back to get a rest and I'm not banking on their return soon"
      response = RosetteAPI.new('0123456789').get_parts_of_speech(params)
      expect(response).instance_of? Hash
    end
  end

  describe '.get_lemmas' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/morphology_lemmas.json'))
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/morphology/lemmas').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'morphology/lemmas'}.to_json, headers: {})
    end
    it 'test morphology lemmas' do
      params = DocumentParameters.new
      params.content = "The fact is that the geese just went back to get a rest and I'm not banking on their return soon"
      response = RosetteAPI.new('0123456789').get_lemmas(params)
      expect(response).instance_of? Hash
    end
  end

  describe '.get_entities' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/entities.json')), encoding: 'utf-8'
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/entities').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'entities'}.to_json, headers: {})
    end
    it 'test entities' do
      params = DocumentParameters.new
      params.content = 'Bill Murray will appear in new Ghostbusters film: Dr. Peter Venkman was spotted filming a' \
                       ' cameo in Boston this… http://dlvr.it/BnsFfS'
      response = RosetteAPI.new('0123456789').get_entities(params)
      expect(response).instance_of? Hash
    end
  end

  describe '.get_entities_no_qids' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/entities_no_qids.json'))
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/entities').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'entities'}.to_json, headers: {})
    end
    it 'test entities without qids' do
      params = DocumentParameters.new
      params.content = 'Last month director Paul Feig announced the movie will have an all-star female cast including' \
                       ' Kristen Wiig, Melissa McCarthy, Leslie Jones and Kate McKinnon.'
      params.rosette_options = { linkEntities: false}
      response = RosetteAPI.new('0123456789').get_entities(params)
      expect(response).instance_of? Hash
    end

    it 'test rosette_options is not a Hash' do
      params = DocumentParameters.new
      params.content = 'Last month director Paul Feig announced the movie will have an all-star female cast including' \
                       ' Kristen Wiig, Melissa McCarthy, Leslie Jones and Kate McKinnon.'
      params.rosette_options = 1
      expect { RosetteAPI.new('0123456789').get_entities(params) }.to raise_error(BadRequestError)
    end
  end

  describe '.get_categories' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/categories.json'))
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/categories').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'categories'}.to_json, headers: {})
    end
    it 'test categories' do
      params = DocumentParameters.new
      params.content_uri = 'http://www.onlocationvacations.com/2015/03/05/the-new-ghostbusters-movie-begins-filming-in-boston-in-june/'
      response = RosetteAPI.new('0123456789').get_categories(params)
      expect(response).instance_of? Hash
    end
  end

  describe '.get_relationships' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/relationships.json'))
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/relationships').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'relationships'}.to_json, headers: {})
    end
    it 'test relationships' do
      params = DocumentParameters.new
      params.content = 'The Ghostbusters movie was filmed in Boston.'
      response = RosetteAPI.new('0123456789').get_relationships(params)
      expect(response).instance_of? Hash
    end
  end

  describe '.name_translation' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/name_translation.json')), encoding: 'utf-8'
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/name-translation').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'name-translation'}.to_json, headers: {})
    end
    it 'test name translation' do
      params = NameTranslationParameters.new('معمر محمد أبو منيار القذاف'.encode('UTF-8'), 'eng')
      params.target_script = 'Latn'
      response = RosetteAPI.new('0123456789').name_translation(params)
      expect(response).instance_of? Hash
    end

    it 'badRequest: Expects NameTransaltionParameters type as an argument' do
      params = NameSimilarityParameters.new('Michael Jackson', '迈克尔·杰克逊')
      expect { RosetteAPI.new('0123456789').name_translation(params) }.to raise_error(BadRequestError)
    end
  end

  describe '.name_similarity' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/name_similarity.json')), encoding: 'utf-8'
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/name-similarity').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'name-similarity'}.to_json, headers: {})
    end
    it 'test name similarity' do
      params = NameSimilarityParameters.new('Michael Jackson', '迈克尔·杰克逊')
      response = RosetteAPI.new('0123456789').name_similarity(params)
      expect(response).instance_of? Hash
    end

    it 'badRequestFormat: name1 option can only be an instance of a String or NameParameter' do
      params = NameSimilarityParameters.new(123, 'Michael Jackson')
      expect { RosetteAPI.new('0123456789').name_similarity(params) }.to raise_error(BadRequestError)
    end

    it 'badRequestFormat: name2 option can only be an instance of a String or NameParameter' do
      params = NameSimilarityParameters.new('Michael Jackson', 123)
      expect { RosetteAPI.new('0123456789').name_similarity(params) }.to raise_error(BadRequestError)
    end

    it 'badRequest: Expects NameSimilarityParameters type as an argument' do
      params = NameTranslationParameters.new('معمر محمد أبو منيار القذاف'.encode('UTF-8'), 'eng')
      expect { RosetteAPI.new('0123456789').name_similarity(params) }.to raise_error(BadRequestError)
    end
  end

  describe '.get_tokens' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/tokens.json')), encoding: 'utf-8'
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/tokens').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'tokens'}.to_json, headers: {})
    end
    it 'test tokens' do
      params = DocumentParameters.new
      params.content = '北京大学生物系主任办公室内部会议'
      response = RosetteAPI.new('0123456789').get_tokens(params)
      expect(response).instance_of? Hash
    end
  end

  describe '.get_sentences' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/sentences.json'))
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/sentences').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1'}).
          to_return(status: 200, body: {'test': 'sentences'}.to_json, headers: {})
    end
    it 'test sentences' do
      params = DocumentParameters.new
      params.content = 'This land is your land. This land is my land\nFrom California to the New York island;\nFrom' \
                       ' the wood forest to the Gulf Stream waters\n\nThis land was made for you and Me.\n\nAs I was' \
                       ' walking that ribbon of highway,\nI saw above me that endless skyway:\nI saw below me that' \
                       ' golden valley:\nThis land was made for you and me.'
      response = RosetteAPI.new('0123456789').get_sentences(params)
      expect(response).instance_of? Hash
    end
  end

  describe '.info' do
    before do
      stub_request(:get, 'https://api.rosette.com/rest/v1/info').
          with(headers: {'Accept' => '*/*',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789'}).
          to_return(status: 200, body: {'test': 'info'}.to_json, headers: {})
    end
    it 'test info' do
      response = RosetteAPI.new('0123456789').info
      expect(response).instance_of? Hash
    end
  end

  describe '.ping' do
    before do
      stub_request(:get, 'https://api.rosette.com/rest/v1/ping').
          with(headers: {'Accept' => '*/*',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789'}).
          to_return(status: 200, body: {'test': 'ping'}.to_json, headers: {})
    end
    it 'test ping' do
      response = RosetteAPI.new('0123456789').ping
      expect(response).instance_of? Hash
    end
  end

  describe '.get_language_custom_header' do
    request_file = File.read File.expand_path(File.join(File.dirname(__FILE__), '../mock-data/request/language.json'))
    before do
      stub_request(:post, 'https://api.rosette.com/rest/v1/language').
          with(body: request_file,
               headers: {'Accept' => 'application/json',
                            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                            'Content-Type' => 'application/json',
                            'User-Agent' => 'Ruby',
                            'X-Rosetteapi-Key' => '0123456789',
                            'X-Rosetteapi-Binding' => 'ruby',
                            'X-Rosetteapi-Binding-Version' => '1.1.1',
                            'X-RosetteApi-App' => 'ruby-app'}).
          to_return(status: 200, body: {'test': 'language'}.to_json, headers: {})
    end

    it 'test custom_headers is invalid' do
      params = DocumentParameters.new
      params.content = 'Por favor Senorita, says the man.?'
      params.custom_headers = { 'test': 'ruby-app'}
      expect { RosetteAPI.new('0123456789').get_language(params) }.to raise_error(RosetteAPIError)
    end
  end

end
