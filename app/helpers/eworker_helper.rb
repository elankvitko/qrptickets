module EworkerHelper
  def compare_pb
    billing_ndc_duplicates = {}
    purchasing_ndc_duplicates = {}
    found = {}

    CSV.foreach( 'billing.csv', headers:true, :header_converters=> lambda { | f | f.strip }, :converters=> lambda { | f | f ? f.strip : nil } ) do | billing |
      if billing[ "CLASS" ].to_i > 0
        if billing_ndc_duplicates[ billing[ "NDC" ].gsub( '-', '' ) ]
          billing_ndc_duplicates[ billing[ "NDC" ].gsub( '-', '' ) ][ 5 ] += billing[ "QUANT" ].to_i
          billing_ndc_duplicates[ billing[ "NDC" ].gsub( '-', '' ) ][ 4 ] += billing[ "TotalInsPaid" ].to_f
        else
          billing_ndc_duplicates[ billing[ "NDC" ].gsub( '-', '' ) ] = [ billing[ "DRGNAME" ], billing[ "DRUGSTRONG" ], billing[ "PACKAGESIZE" ], billing[ "CLASS" ], billing[ "TotalInsPaid" ].to_f, billing[ "QUANT" ].to_i ]
        end
      end
    end

    billing_ndc_duplicates.each { | k,v | v[ 4 ] = v[ 4 ].round( 2 ) }


    CSV.foreach( 'purchasing.csv', headers:true, :header_converters=> lambda { | f | f.strip }, :converters=> lambda { | f | f ? f.strip : nil } ) do | purchasing |
      if purchasing_ndc_duplicates[ purchasing[ "Universal Ndc #" ] ]
        purchasing_ndc_duplicates[ purchasing[ "Universal Ndc #" ] ][ 3 ] += purchasing[ "Quantity Billed" ].to_i
      else
        purchasing_ndc_duplicates[ purchasing[ "Universal Ndc #" ] ] = [ purchasing[ "Item Description" ], purchasing[ "Item Type" ], purchasing[ "Size" ].to_i, purchasing[ "Quantity Billed" ].to_i ]
      end
    end

    purchasing_ndc_duplicates.each do | k, v |
      v << v[ 2 ] * v[ 3 ]
      v.delete_at( 2 )
      v.delete_at( 2 )
    end

    billing_ndc_duplicates.each do | ndc, arr |
      purchasing_ndc_duplicates.each do | ndc2, arr2 |
        if ndc.gsub( /(^|[^0-9])0+/, "" ) == ndc2
          complete = arr.insert( 5, arr2[ 2 ] )
          complete = complete.insert( 0, ndc )
          found[ ndc ] = complete
        end
      end
    end

    CSV.open( "file.csv", "wb", :write_headers=> true, :headers => [ "NDC", "Drug Name", "Drug Strength", "Package Size", "Control", "Total Ins. Paid", "Total Units Purchased", "Total Units Billed" ] ) do | csv |
      found.each do | ndc, arr |
        csv << arr
      end
    end
  end
end
