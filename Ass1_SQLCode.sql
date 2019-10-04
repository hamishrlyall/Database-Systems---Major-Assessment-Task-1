SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE ADD_CUST_TO_DB 
( pcustid IN NUMBER
, pcustname IN VARCHAR2
) AS e_outsiderange EXCEPTION;
BEGIN
    INSERT INTO CUSTOMER(CUSTID,CUSTNAME,SALES_YTD,STATUS)
    VALUES(pcustid, pcustname, 0, 'OK');
    IF pcustid < 1 THEN
        RAISE e_outsiderange;
    ELSIF pcustid > 499 THEN
        RAISE e_outsiderange;
    END IF;
    COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            raise_application_error(-20012., 'Duplicate customer ID');
        WHEN e_outsiderange THEN
            raise_application_error(-20024., 'Customer ID out of range');
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm);    
END ADD_CUST_TO_DB;
/
CREATE OR REPLACE PROCEDURE ADD_CUSTOMER_VIASQLDEV 
( pcustid IN NUMBER
, pcustname IN VARCHAR2
) AS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Adding Customer ' || pcustid || ' Name: ' || pcustname);
    ADD_CUST_TO_DB(pcustid, pcustname);
    dbms_output.put_line( 'Customer Added OK' );
    COMMIT;  
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );      
END ADD_CUSTOMER_VIASQLDEV;
/
CREATE OR REPLACE FUNCTION DELETE_ALL_CUSTOMERS_FROM_DB 
RETURN NUMBER AS
rnumberofrows NUMBER := 0;
BEGIN
    DELETE FROM CUSTOMER;
    rnumberofrows := sql%rowcount;
    RETURN rnumberofrows;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm );
END DELETE_ALL_CUSTOMERS_FROM_DB;
/
CREATE OR REPLACE PROCEDURE DELETE_ALL_CUSTOMERS_VIASQLDEV
IS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Deleting all Customer rows' );
    dbms_output.put_line( DELETE_ALL_CUSTOMERS_FROM_DB || ' rows deleted' );
    COMMIT;  
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
END DELETE_ALL_CUSTOMERS_VIASQLDEV;
/
CREATE OR REPLACE PROCEDURE ADD_PRODUCT_TO_DB
( pprodid IN NUMBER
, pprodname IN VARCHAR2
, pprice IN NUMBER
) AS e_idoutsiderange EXCEPTION;
     e_priceoutsiderange EXCEPTION;
BEGIN
INSERT INTO PRODUCT(PRODID,PRODNAME,SELLING_PRICE,SALES_YTD)
    VALUES(pprodid, pprodname, pprice, 0);
    IF pprodid < 1000 THEN
        RAISE e_idoutsiderange;
    ELSIF pprodid > 2500 THEN
        RAISE e_idoutsiderange;
    ELSIF pprice < 0 THEN
        RAISE e_priceoutsiderange;
    ELSIF pprice > 999.99 THEN
        RAISE e_priceoutsiderange;
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        raise_application_error(-20032., 'Duplicate product ID');
    WHEN e_idoutsiderange THEN
        raise_application_error(-20044., 'Product ID out of range');
    WHEN e_priceoutsiderange THEN
        raise_application_error(-20056., 'Price out of range');    
    WHEN OTHERS THEN
        raise_application_error(-20000., sqlerrm);
END ADD_PRODUCT_TO_DB;
/
CREATE OR REPLACE PROCEDURE ADD_PRODUCT_VIASQLDEV 
( pprodid IN NUMBER
, pprodname IN VARCHAR2
, pprice IN NUMBER 
) AS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Adding Product ' || pprodid || ' Name: ' || pprodname || ' Price: ' || pprice);
    ADD_PRODUCT_TO_DB(pprodid, pprodname, pprice);
    dbms_output.put_line( 'Product Added OK' );
    COMMIT;  
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
END ADD_PRODUCT_VIASQLDEV;
/
CREATE OR REPLACE FUNCTION DELETE_ALL_PRODUCTS_FROM_DB 
RETURN NUMBER AS 
rnumberofrows NUMBER := 0;
BEGIN
    DELETE FROM PRODUCT;
    rnumberofrows := sql%rowcount;
    RETURN rnumberofrows;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm);
END DELETE_ALL_PRODUCTS_FROM_DB;
/
CREATE OR REPLACE PROCEDURE DELETE_ALL_PRODUCTS_VIASQLDEV
IS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Deleting all Product rows' );
    dbms_output.put_line( DELETE_ALL_PRODUCTS_FROM_DB || ' rows deleted' );
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
END DELETE_ALL_PRODUCTS_VIASQLDEV;
/
CREATE OR REPLACE FUNCTION GET_CUST_STRING_FROM_DB
( pcustid IN NUMBER 
)RETURN VARCHAR2 AS rcustomerinfo VARCHAR2(512);
BEGIN
    SELECT 'Custid: ' || pcustid ||
    ' Name: ' || CUSTNAME ||
    ' Status: ' || STATUS ||
    ' SalesYTD: ' || SALES_YTD INTO rcustomerinfo FROM CUSTOMER WHERE CUSTID = pcustid;
    RETURN rcustomerinfo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20062., 'Customer ID not found');
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm);
END GET_CUST_STRING_FROM_DB;
/
CREATE OR REPLACE PROCEDURE GET_CUST_STRING_VIASQLDEV
( pcustid IN NUMBER )
IS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Getting Details for ' || pcustid );
    dbms_output.put_line( GET_CUST_STRING_FROM_DB(pcustid) );
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
END GET_CUST_STRING_VIASQLDEV;
/
CREATE OR REPLACE PROCEDURE UPD_CUST_SALESYTD_IN_DB
( pcustid IN NUMBER
, pamt IN NUMBER
) AS e_outsiderange EXCEPTION;
BEGIN
    IF pamt < -999.99  THEN
        RAISE e_outsiderange;
    ELSIF pamt > 999.99 THEN
        RAISE e_outsiderange;
    ELSE
        UPDATE CUSTOMER
        SET SALES_YTD = pamt
        WHERE CUSTID = pcustid;  
    END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20072., 'Customer ID not found');
        WHEN e_outsiderange THEN
            raise_application_error(-20084., 'Amount out of range');
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm);        
END UPD_CUST_SALESYTD_IN_DB;
/
CREATE OR REPLACE PROCEDURE UPD_CUST_SALESYTD_VIASQLDEV
( pcustid IN NUMBER
, pamt IN NUMBER
) IS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Updating SalesYTD. Customer Id: ' || pcustid || ' Amount: ' || pamt );
    UPD_CUST_SALESYTD_IN_DB( pcustid, pamt );
    dbms_output.put_line( 'Update OK');
    COMMIT;  
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
            ROLLBACK;  
END UPD_CUST_SALESYTD_VIASQLDEV;
/
CREATE OR REPLACE FUNCTION GET_PROD_STRING_FROM_DB
( pprodid IN NUMBER 
)RETURN VARCHAR2 AS rproductinfo VARCHAR2(512);
BEGIN
    SELECT pprodid INTO rproductinfo FROM PRODUCT WHERE PRODID = pprodid;
    rproductinfo := NULL;
    SELECT 'Prodid: ' || pprodid ||
    ' Name: ' || PRODNAME ||
    ' Price: ' || SELLING_PRICE ||
    ' SalesYTD: ' || SALES_YTD INTO rproductinfo FROM PRODUCT WHERE PRODID = pprodid;
    RETURN rproductinfo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20092., 'Product ID not found');
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm);  
END GET_PROD_STRING_FROM_DB;
/
CREATE OR REPLACE PROCEDURE GET_PROD_STRING_VIASQLDEV
( pprodid IN NUMBER
) IS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Getting Details for ProdId: ' || pprodid );
    dbms_output.put_line(GET_PROD_STRING_FROM_DB( pprodid ));
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
END GET_PROD_STRING_VIASQLDEV;
/
CREATE OR REPLACE PROCEDURE UPD_PROD_SALESYTD_IN_DB
( pprodid IN NUMBER
, pamt IN NUMBER
) AS e_outsiderange EXCEPTION; 
BEGIN
    IF pamt < -999.99  THEN
        RAISE e_outsiderange;
    ELSIF pamt > 999.99 THEN
        RAISE e_outsiderange;
    ELSE
        UPDATE PRODUCT
        SET SALES_YTD = pamt
        WHERE PRODID = pprodid;
    END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20102., 'Product ID not found');
        WHEN e_outsiderange THEN
            raise_application_error(-20114., 'Amount out of range');
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm); 
END UPD_PROD_SALESYTD_IN_DB;
/
CREATE OR REPLACE PROCEDURE UPD_PROD_SALESYTD_VIASQLDEV
( pprodid IN NUMBER
, pamt IN NUMBER
) AS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Updating SalesYTD Product Id: ' || pprodid || ' Amount: ' || pamt );
    UPD_PROD_SALESYTD_IN_DB(pprodid, pamt);
    dbms_output.put_line( 'Update OK' );
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
            ROLLBACK;
END UPD_PROD_SALESYTD_VIASQLDEV;
/
CREATE OR REPLACE PROCEDURE UPD_CUST_STATUS_IN_DB
( pcustid IN NUMBER
, pstatus IN VARCHAR2
) AS e_invalidStatus EXCEPTION;
BEGIN
    IF pstatus = 'OK' THEN
        UPDATE CUSTOMER
        SET STATUS = pstatus
        WHERE CUSTID = pcustid;
        IF SQL%NOTFOUND = true THEN
            RAISE NO_DATA_FOUND;
        END IF; 
    ELSIF pstatus = 'SUSPEND' THEN
        UPDATE CUSTOMER
        SET STATUS = pstatus
        WHERE CUSTID = pcustid;
        IF SQL%NOTFOUND = true THEN
            RAISE NO_DATA_FOUND;
        END IF; 
    ELSE
        RAISE e_invalidStatus;
    END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20122., 'Customer ID not found');
        WHEN e_invalidStatus THEN
            raise_application_error(-20134., 'Invalid Status value');
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm);   
END UPD_CUST_STATUS_IN_DB;
/
CREATE OR REPLACE PROCEDURE UPD_CUST_STATUS_VIASQLDEV
( pcustid IN NUMBER
, pstatus IN VARCHAR2
) AS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Updating Status Id: ' || pcustid || ' New Status: ' || pstatus );
    UPD_CUST_STATUS_IN_DB(pcustid, pstatus);
    dbms_output.put_line( 'Update OK' );
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
END UPD_CUST_STATUS_VIASQLDEV;
/
CREATE OR REPLACE PROCEDURE ADD_SIMPLE_SALE_TO_DB
( pcustid IN NUMBER 
, pprodid IN NUMBER
, pqty IN NUMBER
) AS errcode NUMBER; stmt VARCHAR2(128); anyrowsfound NUMBER; tempprice NUMBER; 
e_outsiderange EXCEPTION; e_invalidStatus EXCEPTION;
BEGIN
    errcode := 0.;
    stmt := 'No error found';
    anyrowsfound := 0;
    tempprice := 0;
    
    SELECT COUNT(*) INTO anyrowsfound FROM CUSTOMER WHERE CUSTID = pcustid AND STATUS != 'OK';
    IF anyrowsfound = 1 THEN
        RAISE e_invalidStatus; 
    END IF;
    
    IF pqty < 1  THEN
        RAISE e_outsiderange;
    ELSIF pqty > 999 THEN
        RAISE e_outsiderange;
    END IF;
    
    anyrowsfound := 0;
    SELECT COUNT(*) INTO anyrowsfound FROM PRODUCT WHERE PRODID = pprodid;
    IF anyrowsfound = 1 THEN
    SELECT SELLING_PRICE INTO tempprice FROM PRODUCT WHERE PRODID = pprodid;
        UPD_PROD_SALESYTD_IN_DB( pprodid, pqty * tempprice );
    ELSE
        errcode := -20178.;
        stmt := 'Product ID not found';
        RAISE NO_DATA_FOUND;
    END IF;
    
    anyrowsfound := 0;
    SELECT COUNT(*) INTO anyrowsfound FROM CUSTOMER WHERE CUSTID = pcustid;
    IF anyrowsfound = 1 THEN
        SELECT SELLING_PRICE INTO tempprice FROM PRODUCT WHERE PRODID = pprodid;
        UPD_CUST_SALESYTD_IN_DB( pcustid, pqty * tempprice );
    ELSE
        errcode := -20166.;
        stmt := 'Customer ID not found';
        RAISE NO_DATA_FOUND;
    END IF;
    
    EXCEPTION
        WHEN e_outsiderange THEN
            raise_application_error(-20142., 'Sale Quantity outside valid range');
        WHEN e_invalidStatus THEN
            raise_application_error(-20154., 'Customer Status is not OK');
        WHEN NO_DATA_FOUND THEN
            raise_application_error(errcode, stmt);
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm);
END ADD_SIMPLE_SALE_TO_DB;
/
CREATE OR REPLACE PROCEDURE ADD_SIMPLE_SALE_VIASQLDEV
( pcustid IN NUMBER
, pprodid IN NUMBER
, pqty IN NUMBER
) AS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Updating Status Id: ' || pcustid || ' Prod Id: ' || pprodid || ' Qty: ' || pqty );
    ADD_SIMPLE_SALE_TO_DB(pcustid, pprodid, pqty);
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
END ADD_SIMPLE_SALE_VIASQLDEV;
/
CREATE OR REPLACE FUNCTION SUM_CUST_SALESYTD RETURN NUMBER
AS rsummedvalue NUMBER := 0;
BEGIN
    SELECT SUM(SALES_YTD) INTO rsummedvalue FROM CUSTOMER;
    RETURN rsummedvalue;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
END SUM_CUST_SALESYTD;
/
CREATE OR REPLACE PROCEDURE SUM_CUST_SALES_VIASQLDEV
AS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Summing Customer SalesYTD' );
    dbms_output.put_line( 'All Customer Total: ' || SUM_CUST_SALESYTD );  
    COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
END SUM_CUST_SALES_VIASQLDEV;
/
CREATE OR REPLACE FUNCTION SUM_PROD_SALESYTD_FROM_DB RETURN NUMBER
AS rsummedvalue NUMBER := 0;
BEGIN
    SELECT SUM(SALES_YTD) INTO rsummedvalue FROM PRODUCT;
    RETURN rsummedvalue;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
END SUM_PROD_SALESYTD_FROM_DB;
/
CREATE OR REPLACE PROCEDURE SUM_PROD_SALES_VIASQLDEV
AS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Summing Product SalesYTD' );
    dbms_output.put_line( 'All Product Total: ' || SUM_PROD_SALESYTD_FROM_DB ) ;  
    COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );
END SUM_PROD_SALES_VIASQLDEV;
/
CREATE OR REPLACE FUNCTION GET_ALLCUST RETURN SYS_REFCURSOR
AS rcustdetailscursor SYS_REFCURSOR; 
BEGIN
    OPEN rcustdetailscursor FOR
    SELECT CUSTID ,CUSTNAME ,SALES_YTD ,STATUS
    FROM CUSTOMER ORDER BY CUSTID;
    RETURN rcustdetailscursor;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm);
END GET_ALLCUST;
/
CREATE OR REPLACE PROCEDURE GET_ALLCUST_VIASQLDEV
AS  tcursor SYS_REFCURSOR; 
    tcustid CUSTOMER.CUSTID%TYPE; 
    tcustname CUSTOMER.CUSTNAME%TYPE; 
    tsalesytd CUSTOMER.SALES_YTD%TYPE; 
    tstatus CUSTOMER.STATUS%TYPE;
    tcount NUMBER := 0;
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Listing All Customer Details' );
    tcursor := GET_ALLCUST;
    LOOP
        FETCH tcursor
        INTO tcustid, tcustname, tsalesytd, tstatus;
        IF tcursor%FOUND THEN
            dbms_output.put_line( 'Custid: ' || tcustid || ' Name: ' || tcustname || ' Status: ' || tstatus || ' SalesYTD:' || tsalesytd );  
            tcount := tcount + 1;
        END IF;
        EXIT WHEN tcursor%NOTFOUND;
    END LOOP;
    CLOSE tcursor;
    IF tcount = 0 THEN
        dbms_output.put_line('No rows found.');
    END IF;    
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlerrm); 
END GET_ALLCUST_VIASQLDEV;
/
CREATE OR REPLACE FUNCTION GET_ALLPROD_FROM_DB RETURN SYS_REFCURSOR
AS rproddetailscursor SYS_REFCURSOR;
BEGIN
    OPEN rproddetailscursor FOR
    SELECT PRODID ,PRODNAME ,SELLING_PRICE ,SALES_YTD
    FROM PRODUCT ORDER BY PRODID;
    RETURN rproddetailscursor;
    EXCEPTION
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm);
END GET_ALLPROD_FROM_DB;
/
CREATE OR REPLACE PROCEDURE GET_ALLPROD_VIASQLDEV
AS  tcursor SYS_REFCURSOR; 
    tprodid PRODUCT.PRODID%TYPE; 
    tprodname PRODUCT.PRODNAME%TYPE; 
    tsalesytd PRODUCT.SALES_YTD%TYPE; 
    tsellingprice PRODUCT.SELLING_PRICE%TYPE;
    tcount NUMBER := 0;
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Listing All Product Details' );
    tcursor := GET_ALLPROD_FROM_DB;
    LOOP
        FETCH tcursor
        INTO tprodid, tprodname, tsalesytd, tsellingprice;
        IF tcursor%FOUND THEN
            dbms_output.put_line( 'Prodid: ' || tprodid || ' Name: ' || tprodname || ' Price: ' || tsellingprice || ' SalesYTD:' || tsalesytd );  
            tcount := tcount + 1;
        END IF;
        EXIT WHEN tcursor%NOTFOUND;
    END LOOP;
    CLOSE tcursor;
    IF tcount = 0 THEN
        dbms_output.put_line('No rows found.');
    END IF;    
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlerrm); 
END GET_ALLPROD_VIASQLDEV;
/
CREATE OR REPLACE PROCEDURE ADD_LOCATION_TO_DB
( ploccode IN VARCHAR2
, pminqty IN NUMBER
, pmaxqty IN NUMBER
) AS eidlengthexception EXCEPTION; 
     eminqtyrangeexception EXCEPTION; 
     emaxrangecheckexception EXCEPTION; 
     emingreaterthanmaxexception EXCEPTION;
BEGIN
    IF LENGTH(ploccode) != 5 THEN
        RAISE eidlengthexception;
    ELSIF pminqty < 0 OR pminqty > 999 THEN
        RAISE eminqtyrangeexception;
    ELSIF pmaxqty < 0 OR pmaxqty > 999 THEN
        RAISE emaxrangecheckexception;
    ELSIF pmaxqty < pminqty THEN
        RAISE emingreaterthanmaxexception;
    ELSE
        INSERT INTO LOCATION(LOCID, MINQTY, MAXQTY)
        VALUES(ploccode, pminqty, pmaxqty);
    END IF;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            raise_application_error(-20182., 'Duplicate location ID');
        WHEN eidlengthexception THEN
            raise_application_error(-20194., 'Location Code length invalid');
        WHEN eminqtyrangeexception THEN
            raise_application_error(-20206., 'Minimum Qty out of range');
        WHEN emaxrangecheckexception THEN
            raise_application_error(-20218., 'Maximum Qty out of range');
        WHEN emingreaterthanmaxexception THEN
            raise_application_error(-20229., 'Minimum Qty larger than Maximum Qty');
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm );
END ADD_LOCATION_TO_DB;
/
CREATE OR REPLACE PROCEDURE ADD_LOCATION_VIASQLDEV 
( ploccode IN VARCHAR2
, pminqty IN NUMBER
, pmaxqty IN NUMBER
) AS
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    dbms_output.put_line( 'Adding Locaiton ' || ploccode || ' MinQty: ' || pminqty || ' MaxQty: ' || pmaxqty );
    ADD_LOCATION_TO_DB(ploccode, pminqty, pmaxqty);
    dbms_output.put_line( 'Location Added OK' );
    COMMIT;  
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );      
END ADD_LOCATION_VIASQLDEV;
/
CREATE OR REPLACE FUNCTION IS_DATE_FORMAT_OK
( pdate IN VARCHAR2
)RETURN BOOLEAN AS tempdate DATE; edayofmonth EXCEPTION; enotnumeric EXCEPTION;
BEGIN
    SELECT TO_DATE( pdate, 'yyyymmdd') into tempdate from dual;
    RETURN TRUE;
    EXCEPTION
        WHEN edayofmonth THEN
            dbms_output.put_line( 'Day of month invalid'); 
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm);
            RETURN FALSE;
END IS_DATE_FORMAT_OK;
/
CREATE OR REPLACE PROCEDURE ADD_COMPLEX_SALE_TO_DB
( pcustid IN NUMBER
, pprodid IN NUMBER
, pqty IN NUMBER
, pdate IN VARCHAR2
) AS errcode NUMBER := 0; 
     stmt VARCHAR2(128); 
     anyrowsfound NUMBER := 0; 
     tempprice NUMBER := 0;
     tempYTD NUMBER := 0;
     tempdate DATE; 
     tcheck BOOLEAN; 
e_outsiderange EXCEPTION; e_invalidStatus EXCEPTION; e_invalidsaledate EXCEPTION;
BEGIN
   SELECT COUNT(*) INTO anyrowsfound FROM CUSTOMER WHERE CUSTID = pcustid AND STATUS != 'OK';
    IF anyrowsfound = 1 THEN
        RAISE e_invalidStatus; 
    END IF; 
    
    IF pqty < 1  THEN
        RAISE e_outsiderange;
    ELSIF pqty > 999 THEN
        RAISE e_outsiderange;
    END IF;
    
    tcheck := IS_DATE_FORMAT_OK(pdate);
    IF tcheck = FALSE THEN
        RAISE e_invalidsaledate;
    ELSE SELECT TO_DATE( pdate, 'yyyymmdd') into tempdate from dual;    
    END IF;
    
    anyrowsfound := 0;
    SELECT COUNT(*) INTO anyrowsfound FROM PRODUCT WHERE PRODID = pprodid;
    IF anyrowsfound = 1 THEN
        SELECT SELLING_PRICE INTO tempprice FROM PRODUCT WHERE PRODID = pprodid;
        SELECT SALES_YTD INTO tempYTD FROM PRODUCT WHERE PRODID = pprodid;
        tempYTD := tempYTD + ( pqty * tempprice );
        UPD_PROD_SALESYTD_IN_DB( pprodid, tempYTD );
    ELSE
        errcode := -20279.;
        stmt := 'Product ID not found';
        RAISE NO_DATA_FOUND;
    END IF;
    
    anyrowsfound := 0;
    tempYTD := 0;
    SELECT COUNT(*) INTO anyrowsfound FROM CUSTOMER WHERE CUSTID = pcustid;
    IF anyrowsfound = 1 THEN
        SELECT SALES_YTD INTO tempYTD FROM CUSTOMER WHERE CUSTID = pcustid;
        tempYTD := tempYTD + ( pqty * tempprice );
        UPD_CUST_SALESYTD_IN_DB( pcustid, pqty * tempprice );
    ELSE
        errcode := -20268.;
        stmt := 'Customer ID not found';
        RAISE NO_DATA_FOUND;
    END IF;
    
    INSERT INTO SALE(SALEID,CUSTID,PRODID,QTY,PRICE,SALEDATE)
    VALUES(SALE_SEQ.nextval, pcustid, pprodid, pqty, tempprice, tempdate);
   
    EXCEPTION
        WHEN e_outsiderange THEN
            raise_application_error(-20232., 'Sale Quantity outside valid range');
        WHEN e_invalidStatus THEN
            raise_application_error(-20244., 'Customer Status is not OK');
        WHEN e_invalidsaledate THEN
            raise_application_error(-20256.,  'Date not valid');
        WHEN NO_DATA_FOUND THEN
            raise_application_error(errcode, stmt);
        WHEN OTHERS THEN
            raise_application_error(-20000., sqlerrm);
END ADD_COMPLEX_SALE_TO_DB;
/
CREATE OR REPLACE PROCEDURE ADD_COMPLEX_SALE_VIASQLDEV 
( pcustid IN NUMBER
, pprodid IN NUMBER
, pqty IN NUMBER
, pdate IN VARCHAR2
) AS anyrowsfound NUMBER := 0; tempprice NUMBER := 0;
BEGIN
    dbms_output.put_line( '--------------------------------------------' );
    SELECT COUNT(*) INTO anyrowsfound FROM PRODUCT WHERE PRODID = pprodid;
    IF anyrowsfound = 1 THEN
        SELECT SELLING_PRICE INTO tempprice FROM PRODUCT WHERE PRODID = pprodid;
    END IF;    
    dbms_output.put_line( 'Adding Complex Sale. Cust Id: ' || pcustid || ' Prod Id: ' || pprodid || ' Date: ' || pdate || ' Amt: ' || pqty );
    ADD_COMPLEX_SALE_TO_DB(pcustid, pprodid, pqty, pdate);
    dbms_output.put_line( 'Added Complex Sale OK' );
    COMMIT;  
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line( sqlerrm );      
END ADD_COMPLEX_SALE_VIASQLDEV;
/
CREATE OR REPLACE FUNCTION GET_ALLSALES_FROM_DB RETURN SYS_REFCURSOR
AS rv_Sales SYS_REFCURSOR;
BEGIN
  OPEN rv_Sales FOR SELECT * FROM SALE;
  RETURN rv_Sales;
  EXCEPTION
      WHEN OTHERS THEN
          raise_application_error(-20000., sqlerrm );
          RETURN rv_Sales;
END GET_ALLSALES_FROM_DB;
/
CREATE OR REPLACE PROCEDURE GET_ALLSALES_VIASQLDEV
AS rv_Sales SYS_REFCURSOR; salerec SALE%ROWTYPE; tcount NUMBER := 0;
BEGIN
  dbms_output.put_line( '--------------------------------------------' );
  dbms_output.put_line('Listing All Complex Sales Details');
  rv_Sales := GET_ALLSALES_FROM_DB;
  LOOP
    FETCH rv_Sales INTO salerec;
    EXIT WHEN rv_Sales%NOTFOUND;
    IF rv_Sales%FOUND THEN
      dbms_output.put_line( 'Saleid: ' || salerec.SALEID ||
                            'Custid: ' || salerec.CUSTID || 
                            'Date ' || salerec.SALEDATE || 
                            'Amount: ' || salerec.PRICE * salerec.QTY );
      tcount := tcount + 1;                      
    END IF;      
  END LOOP;
  CLOSE rv_Sales;
  IF tcount = 0 THEN
      dbms_output.put_line( 'No rows found.');
  END IF; 
  EXCEPTION
      WHEN OTHERS THEN
          dbms_output.put_line(sqlerrm);
END GET_ALLSALES_VIASQLDEV;
/
CREATE OR REPLACE FUNCTION COUNT_PRODUCT_SALES_FROM_DB
( pdays IN NUMBER)
RETURN NUMBER
AS rsalescount NUMBER; tempdate DATE; todaysdate DATE;
BEGIN
  SELECT CURRENT_DATE INTO todaysdate FROM DUAL;
  tempdate := todaysdate - pdays;
  SELECT COUNT(*) INTO rsalescount FROM SALE WHERE SALEDATE >= tempdate;
  RETURN rsalescount;
  EXCEPTION
    WHEN OTHERS THEN 
      raise_application_error(-20000., sqlerrm);
      RETURN -1;
END COUNT_PRODUCT_SALES_FROM_DB;
/
CREATE OR REPLACE PROCEDURE COUNT_PRODUCT_SALES_VIASQLDEV
(pdays IN NUMBER)
AS
BEGIN
  dbms_output.put_line( '--------------------------------------------' );
  dbms_output.put_line('Counting sales within ' || pdays );
  dbms_output.put_line( 'Total number of sales: ' );
  dbms_output.put_line( COUNT_PRODUCT_SALES_FROM_DB(pdays) );
  EXCEPTION
    WHEN OTHERS THEN 
      dbms_output.put_line( sqlerrm ); 
END COUNT_PRODUCT_SALES_VIASQLDEV;
/
CREATE OR REPLACE FUNCTION DELETE_SALE_FROM_DB 
RETURN NUMBER
AS firstsaleid NUMBER := -1; saleamt NUMBER; tcustid NUMBER; tprodid NUMBER;
BEGIN
  SELECT MIN(SALEID) INTO firstsaleid FROM SALE;
  SELECT SUM(PRICE * QTY) INTO saleamt FROM SALE WHERE firstsaleid = SALEID; 
  SELECT CUSTID INTO tcustid FROM SALE WHERE firstsaleid = SALEID;
  SELECT PRODID INTO tprodid FROM SALE WHERE firstsaleid = SALEID;
  DELETE FROM SALE WHERE saleid = SALEID;
  UPD_CUST_SALESYTD_IN_DB( tcustid, -saleamt);
  UPD_PROD_SALESYTD_IN_DB( tprodid, -saleamt);  
  RETURN firstsaleid;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error(-20282., 'No Sale Rows Found');
    WHEN OTHERS THEN
      raise_application_error(-20000., sqlerrm);
END DELETE_SALE_FROM_DB;
/
CREATE OR REPLACE PROCEDURE DELETE_SALE_VIASQLDEV
AS saleid NUMBER;
BEGIN
  dbms_output.put_line('--------------------------------------------');
  dbms_output.put_line('Deleting Sale with smallest SaleId value');
  saleid := DELETE_SALE_FROM_DB;
  COMMIT;
  dbms_output.put_line('Deleted Sale OK. SaleId: ' || saleid);
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line(sqlerrm);
      ROLLBACK;
END DELETE_SALE_VIASQLDEV;
/
CREATE OR REPLACE PROCEDURE DELETE_ALL_SALES_FROM_DB
AS salerec SALE%ROWTYPE; CURSOR tcursor IS SELECT * FROM SALE; amountdeleted NUMBER;
BEGIN
  OPEN tcursor;
  LOOP
    FETCH tcursor into salerec;
    EXIT WHEN tcursor%NOTFOUND;
    IF tcursor%FOUND THEN
      amountdeleted := salerec.PRICE * salerec.QTY;
      UPD_CUST_SALESYTD_IN_DB( salerec.CUSTID, -amountdeleted );
      UPD_PROD_SALESYTD_IN_DB( salerec.PRODID, -amountdeleted );
    END IF; 
  END LOOP;
  CLOSE tcursor;
  DELETE FROM SALE;
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line(sqlerrm);
END DELETE_ALL_SALES_FROM_DB;
/
CREATE OR REPLACE PROCEDURE DELETE_ALL_SALES_VIASQLDEV
AS
BEGIN
  dbms_output.put_line('--------------------------------------------');
  dbms_output.put_line('Deleting all Sales data in Sale, Customer, and Product tables');
  DELETE_ALL_SALES_FROM_DB;
  COMMIT;
  dbms_output.put_line('Deletion Ok');
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line(sqlerrm);
      ROLLBACK;
END DELETE_ALL_SALES_VIASQLDEV;
/