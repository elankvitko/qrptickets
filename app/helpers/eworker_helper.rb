module EworkerHelper
  def compare_pb
    CSV.foreach( 'billing.csv', headers:true ) do | billing |
      CSV.foreach( 'purchasing.csv', headers:true ) do | purchasing |
        binding.pry
      end
    end
  end
end
