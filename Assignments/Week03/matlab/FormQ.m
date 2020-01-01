function [ A_out ] = FormQ_unb( A, t )

% Partitioning A and t is a bit tricky.  They should start in the
% configuration in which HQR finished, because in forming Q we run
% through those backward.  Thus, ATL starts being n x n and tT 
% initially has n elements.
    
    [ m, n ] = size( A );
  
  [ ATL, ATR, ...
    ABL, ABR ] = FLA_Part_2x2( A, ...
                               n, n, 'FLA_TL' );

  [ tT, ...
    tB ] = FLA_Part_2x1( t, ...
                         n, 'FLA_TO' );

  while ( size( ABR, 1 ) < size( A, 1 ) )

    [ A00,  a01,     A02,  ...
      a10t, alpha11, a12t, ...
      A20,  a21,     A22 ] = FLA_Repart_2x2_to_3x3( ATL, ATR, ...
                                                    ABL, ABR, ...
                                                    1, 1, 'FLA_TL' );

    [ t0, ...
      tau1, ...
      t2 ] = FLA_Repart_2x1_to_3x1( tT, ...
                                    tB, ...
                                    1, 'FLA_TOP' );

    %------------------------------------------------------------%

    alpha11 = 1 - 1/tau1;
    a12t = -( a21' * A22 ) / tau1;
    A22 = A22 + a21 * a12t;
    a21 = -a21 / tau1;

    %------------------------------------------------------------%

    [ ATL, ATR, ...
      ABL, ABR ] = FLA_Cont_with_3x3_to_2x2( A00,  a01,     A02,  ...
                                             a10t, alpha11, a12t, ...
                                             A20,  a21,     A22, ...
                                             'FLA_BR' );

    [ tT, ...
      tB ] = FLA_Cont_with_3x1_to_2x1( t0, ...
                                       tau1, ...
                                       t2, ...
                                       'FLA_BOTTOM' );

  end

  A_out = [ ATL, ATR
            ABL, ABR ];

return