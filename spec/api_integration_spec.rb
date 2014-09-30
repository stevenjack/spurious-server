require 'helper/spec'

describe 'Spurious server API' do

  describe '/start' do
    context 'Starting the spurious docker containers' do
      let (:expected_response) do
      {

      }
      end
      get '/start'



      specify do
        expect(last_response).to be_ok
        expect(last_response.body).to eq(expected_response)
      end
    end

  end

end
