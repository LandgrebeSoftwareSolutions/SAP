class ZCL_FIORI_GW definition
  public
  inheriting from /IWBEP/CL_MGW_ABS_DATA
  create public .

public section.

  data GV_MSG_TEXT type BAPI_MSG .
  data GO_MSG_CONTAINER type ref to /IWBEP/IF_MESSAGE_CONTAINER .

  methods CONSTRUCTOR
    importing
      !IR_CONTEXT type ref to /IWBEP/IF_MGW_CONTEXT optional .
  methods SET_MESSAGE_CONTAINER
    importing
      !IV_MSG_CONTAINER type ref to /IWBEP/IF_MESSAGE_CONTAINER .
protected section.

  methods ADD_MSG_2_BAPI_RETURN
    importing
      !IV_MSGID type SYMSGID default SY-MSGID
      !IV_MSGTY type SYMSGTY default SY-MSGTY
      !IV_MSGNO type SYMSGNO default SY-MSGNO
      !IV_MSGV1 type SYMSGV default SY-MSGV1
      !IV_MSGV2 type SYMSGV default SY-MSGV2
      !IV_MSGV3 type SYMSGV default SY-MSGV3
      !IV_MSGV4 type SYMSGV default SY-MSGV4
      !IV_BAPI_MSG type BAPI_MSG optional
    exporting
      !ES_BAPIRET2 type BAPIRET2
      !ET_BAPIRET2 type BAPIRET2_T .
  methods ADD_MSG_2_MSG_CONTAINER
    importing
      !IV_MSGID type SYMSGID default SY-MSGID
      !IV_MSGTY type SYMSGTY default SY-MSGTY
      !IV_MSGNO type SYMSGNO default SY-MSGNO
      !IV_MSGV1 type SYMSGV default SY-MSGV1
      !IV_MSGV2 type SYMSGV default SY-MSGV2
      !IV_MSGV3 type SYMSGV default SY-MSGV3
      !IV_MSGV4 type SYMSGV default SY-MSGV4
      !IV_MSG_TEXT type BAPI_MSG optional
      !IR_MSG_CONTAINER type ref to /IWBEP/IF_MESSAGE_CONTAINER
      !IV_ERROR_CATEGORY type /IWBEP/IF_MESSAGE_CONTAINER=>TY_ERROR_CATEGORY default /IWBEP/IF_MESSAGE_CONTAINER=>GCS_ERROR_CATEGORY-PROCESSING
      !IV_IS_LEADING_MESSAGE type ABAP_BOOL default ABAP_TRUE
      !IV_ADD_TO_RESPONSE_HEADER type /IWBEP/SUP_MC_ADD_TO_RESPONSE default ABAP_TRUE .
  methods CONV_DATE_2_TIMESTAMP
    importing
      !IV_DATE type DATUM
      !IV_TIME type UZEIT default '000000'
      !IV_TIME_ZONE type SYST_ZONLO default SY-ZONLO
    returning
      value(RV_TIMESTAMP) type TIMESTAMPL .
  methods CONV_TIMESTAMP_2_DATE
    importing
      value(IV_TIMESTAMP) type TIMESTAMPL
      !IV_TIME_ZONE type SYST_ZONLO default SY-ZONLO
    exporting
      !EV_DATE type DATUM
      !EV_TIME type UZEIT .
  methods EVAL_BAPI_MSG_TAB
    importing
      !IT_BAPIRET2 type BAPIRET2_T
    exporting
      !EV_ERROR type FLAG
      !ET_RETURN type BAPIRET2_T .
  methods HANDLE_EXCEPTION
    importing
      !IT_RETURN type BAPIRET2_T optional
      !IS_RETURN type BAPIRET2 optional
      !IO_EXCEPTION type ref to /IWBEP/CX_MGW_BASE_EXCEPTION optional
      !IV_MSG_TEXT type BAPI_MSG optional
      !IV_MSG_UNLIMITED type STRING optional
      !IV_DETERMINE_LEADING_MSG type /IWBEP/IF_MESSAGE_CONTAINER=>TY_LEADING_MSG_FLAG default /IWBEP/IF_MESSAGE_CONTAINER=>GCS_LEADING_MSG_SEARCH_OPTION-FIRST
      !IV_MSG_TYPE type SYMSGTY default SY-MSGTY
      !IV_MSG_ID type SYMSGID default SY-MSGID
      !IV_MSG_NUMBER type SYMSGNO default SY-MSGNO
      !IV_MSG_V1 type SYMSGV default SY-MSGV1
      !IV_MSG_V2 type SYMSGV default SY-MSGV2
      !IV_MSG_V3 type SYMSGV default SY-MSGV3
      !IV_MSG_V4 type SYMSGV default SY-MSGV4
      !IV_ERROR_CATEGORY type /IWBEP/IF_MESSAGE_CONTAINER=>TY_ERROR_CATEGORY default /IWBEP/IF_MESSAGE_CONTAINER=>GCS_ERROR_CATEGORY-PROCESSING
      !IV_IS_LEADING_MESSAGE type ABAP_BOOL default ABAP_TRUE
      !IV_ENTITY_TYPE type STRING optional
      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR optional
      !IV_ADD_TO_RESPONSE_HEADER type /IWBEP/SUP_MC_ADD_TO_RESPONSE default ABAP_FALSE
      !IV_MESSAGE_TARGET type /IWBEP/SUP_MC_MESSAGE_TARGET optional
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION
      /IWBEP/CX_MGW_TECH_EXCEPTION .
  methods RETURN_ENTITYSET_COUNT
    importing
      !IT_ENTITYSET type ANY TABLE
    changing
      !CHS_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT .
  methods SORT_GW_ENTITYSET
    importing
      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITYSET
      !IS_DEFAULT type ABAP_SORTORDER optional
    changing
      !CH_T_DATA type ANY TABLE .
private section.
ENDCLASS.



CLASS ZCL_FIORI_GW IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_FIORI_GW->ADD_MSG_2_BAPI_RETURN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MSGID                       TYPE        SYMSGID (default =SY-MSGID)
* | [--->] IV_MSGTY                       TYPE        SYMSGTY (default =SY-MSGTY)
* | [--->] IV_MSGNO                       TYPE        SYMSGNO (default =SY-MSGNO)
* | [--->] IV_MSGV1                       TYPE        SYMSGV (default =SY-MSGV1)
* | [--->] IV_MSGV2                       TYPE        SYMSGV (default =SY-MSGV2)
* | [--->] IV_MSGV3                       TYPE        SYMSGV (default =SY-MSGV3)
* | [--->] IV_MSGV4                       TYPE        SYMSGV (default =SY-MSGV4)
* | [--->] IV_BAPI_MSG                    TYPE        BAPI_MSG(optional)
* | [<---] ES_BAPIRET2                    TYPE        BAPIRET2
* | [<---] ET_BAPIRET2                    TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_msg_2_bapi_return.
*----------------------------------------------------------------------*
* Author          : Paul Landgrebe (Mindset) / PLANDGRE
* Creation Date   : 26 OCT 2017
* Technical design: Fiori Sales Enablement
* Description     : This method adds the message in SY-MSGNO to the
*                     BAPI return structure / table.
*----------------------------------------------------------------------*
* Modification Information
*----------------------------------------------------------------------*
* Date            : <DD-MMM-YYYY>
* Author          : <Name of the programmer/Programmer user ID>
* Change request  : <Change request number>
* Transport number: <Transport number>
* Description     : <Short description of changes>
*----------------------------------------------------------------------*


    CALL METHOD zcl_fiori_util=>add_msg_2_bapi_return
      EXPORTING
        iv_msgid    = iv_msgid
        iv_msgty    = iv_msgty
        iv_msgno    = iv_msgno
        iv_msgv1    = iv_msgv1
        iv_msgv2    = iv_msgv2
        iv_msgv3    = iv_msgv3
        iv_msgv4    = iv_msgv4
        iv_bapi_msg = iv_bapi_msg
      IMPORTING
        es_bapiret2 = es_bapiret2
        et_bapiret2 = et_bapiret2.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_FIORI_GW->ADD_MSG_2_MSG_CONTAINER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MSGID                       TYPE        SYMSGID (default =SY-MSGID)
* | [--->] IV_MSGTY                       TYPE        SYMSGTY (default =SY-MSGTY)
* | [--->] IV_MSGNO                       TYPE        SYMSGNO (default =SY-MSGNO)
* | [--->] IV_MSGV1                       TYPE        SYMSGV (default =SY-MSGV1)
* | [--->] IV_MSGV2                       TYPE        SYMSGV (default =SY-MSGV2)
* | [--->] IV_MSGV3                       TYPE        SYMSGV (default =SY-MSGV3)
* | [--->] IV_MSGV4                       TYPE        SYMSGV (default =SY-MSGV4)
* | [--->] IV_MSG_TEXT                    TYPE        BAPI_MSG(optional)
* | [--->] IR_MSG_CONTAINER               TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* | [--->] IV_ERROR_CATEGORY              TYPE        /IWBEP/IF_MESSAGE_CONTAINER=>TY_ERROR_CATEGORY (default =/IWBEP/IF_MESSAGE_CONTAINER=>GCS_ERROR_CATEGORY-PROCESSING)
* | [--->] IV_IS_LEADING_MESSAGE          TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [--->] IV_ADD_TO_RESPONSE_HEADER      TYPE        /IWBEP/SUP_MC_ADD_TO_RESPONSE (default =ABAP_TRUE)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_msg_2_msg_container.
*----------------------------------------------------------------------*
* Author          : Paul Landgrebe (Mindset) / PLANDGRE
* Creation Date   : 26 OCT 2017
* Technical design: Fiori Sales Enablement
* Description     : This method transfers the SY message to the
*                     message container.
*----------------------------------------------------------------------*
* Modification Information
*----------------------------------------------------------------------*
* Date            : <DD-MMM-YYYY>
* Author          : <Name of the programmer/Programmer user ID>
* Change request  : <Change request number>
* Transport number: <Transport number>
* Description     : <Short description of changes>
*----------------------------------------------------------------------*

    "
    CALL METHOD zcl_fiori_util=>add_msg_2_msg_container
      EXPORTING
        iv_msgid                  = iv_msgid
        iv_msgty                  = iv_msgty
        iv_msgno                  = iv_msgno
        iv_msgv1                  = iv_msgv1
        iv_msgv2                  = iv_msgv2
        iv_msgv3                  = iv_msgv3
        iv_msgv4                  = iv_msgv4
        iv_msg_text               = iv_msg_text
        ir_msg_container          = ir_msg_container
        iv_error_category         = iv_error_category
        iv_is_leading_message     = iv_is_leading_message
        iv_add_to_response_header = iv_add_to_response_header.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_FIORI_GW->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IR_CONTEXT                     TYPE REF TO /IWBEP/IF_MGW_CONTEXT(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
*----------------------------------------------------------------------*
* Author          : Paul Landgrebe (Mindset) / PLANDGRE
* Creation Date   : 26 OCT 2017
* Technical design: Fiori Sales Enablement
* Description     : This method handles the initial activities when
*                     the class is instanciated.
*----------------------------------------------------------------------*
* Modification Information
*----------------------------------------------------------------------*
* Date            : <DD-MMM-YYYY>
* Author          : <Name of the programmer/Programmer user ID>
* Change request  : <Change request number>
* Transport number: <Transport number>
* Description     : <Short description of changes>
*----------------------------------------------------------------------*

    super->constructor( ).

    IF ir_context IS BOUND.
      mo_context = ir_context.
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_FIORI_GW->CONV_DATE_2_TIMESTAMP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATE                        TYPE        DATUM
* | [--->] IV_TIME                        TYPE        UZEIT (default ='000000')
* | [--->] IV_TIME_ZONE                   TYPE        SYST_ZONLO (default =SY-ZONLO)
* | [<-()] RV_TIMESTAMP                   TYPE        TIMESTAMPL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD conv_date_2_timestamp.
*----------------------------------------------------------------------*
* Author          : Paul Landgrebe (Mindset) / PLANDGRE
* Creation Date   : 26 OCT 2017
* Technical design: Fiori Sales Enablement
* Description     : This method converts the date into the timestamp
*                     value used by GW.  This allows us to make
*                     adjustments to date handling in a central method.
*----------------------------------------------------------------------*
* Modification Information
*----------------------------------------------------------------------*
* Date            : <DD-MMM-YYYY>
* Author          : <Name of the programmer/Programmer user ID>
* Change request  : <Change request number>
* Transport number: <Transport number>
* Description     : <Short description of changes>
*----------------------------------------------------------------------*

    rv_timestamp = zcl_fiori_util=>conv_date_2_timestamp(
                         EXPORTING
                           iv_date      = iv_date
                           iv_time      = iv_time
                           iv_time_zone = iv_time_zone ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_FIORI_GW->CONV_TIMESTAMP_2_DATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TIMESTAMP                   TYPE        TIMESTAMPL
* | [--->] IV_TIME_ZONE                   TYPE        SYST_ZONLO (default =SY-ZONLO)
* | [<---] EV_DATE                        TYPE        DATUM
* | [<---] EV_TIME                        TYPE        UZEIT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD conv_timestamp_2_date.
*----------------------------------------------------------------------*
* Author          : Paul Landgrebe (Mindset) / PLANDGRE
* Creation Date   : 26 OCT 2017
* Technical design: Fiori Sales Enablement
* Description     : This method converts the date into the timestamp
*                     value used by GW.  This allows us to make
*                     adjustments to date handling in a central method.
*----------------------------------------------------------------------*
* Modification Information
*----------------------------------------------------------------------*
* Date            : <DD-MMM-YYYY>
* Author          : <Name of the programmer/Programmer user ID>
* Change request  : <Change request number>
* Transport number: <Transport number>
* Description     : <Short description of changes>
*----------------------------------------------------------------------*

    CALL METHOD zcl_fiori_util=>conv_timestamp_2_date
      EXPORTING
        iv_timestamp = iv_timestamp
        iv_time_zone = iv_time_zone
      IMPORTING
        ev_date      = ev_date
        ev_time      = ev_time.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_FIORI_GW->EVAL_BAPI_MSG_TAB
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_BAPIRET2                    TYPE        BAPIRET2_T
* | [<---] EV_ERROR                       TYPE        FLAG
* | [<---] ET_RETURN                      TYPE        BAPIRET2_T
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD eval_bapi_msg_tab.
*----------------------------------------------------------------------*
* Author          : Paul Landgrebe (Mindset) / PLANDGRE
* Creation Date   : 26 OCT 2017
* Technical design: Fiori Sales Enablement
* Description     : This method evaluates the list of messages in the
*                     BAPI return table, and sets the error flag.
*----------------------------------------------------------------------*
* Modification Information
*----------------------------------------------------------------------*
* Date            : <DD-MMM-YYYY>
* Author          : <Name of the programmer/Programmer user ID>
* Change request  : <Change request number>
* Transport number: <Transport number>
* Description     : <Short description of changes>
*----------------------------------------------------------------------*

    CALL METHOD zcl_fiori_util=>eval_bapi_msg_tab
      EXPORTING
        it_bapiret2 = it_bapiret2
      IMPORTING
        ev_error    = ev_error
        et_return   = et_return.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_FIORI_GW->HANDLE_EXCEPTION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_RETURN                      TYPE        BAPIRET2_T(optional)
* | [--->] IS_RETURN                      TYPE        BAPIRET2(optional)
* | [--->] IO_EXCEPTION                   TYPE REF TO /IWBEP/CX_MGW_BASE_EXCEPTION(optional)
* | [--->] IV_MSG_TEXT                    TYPE        BAPI_MSG(optional)
* | [--->] IV_MSG_UNLIMITED               TYPE        STRING(optional)
* | [--->] IV_DETERMINE_LEADING_MSG       TYPE        /IWBEP/IF_MESSAGE_CONTAINER=>TY_LEADING_MSG_FLAG (default =/IWBEP/IF_MESSAGE_CONTAINER=>GCS_LEADING_MSG_SEARCH_OPTION-FIRST)
* | [--->] IV_MSG_TYPE                    TYPE        SYMSGTY (default =SY-MSGTY)
* | [--->] IV_MSG_ID                      TYPE        SYMSGID (default =SY-MSGID)
* | [--->] IV_MSG_NUMBER                  TYPE        SYMSGNO (default =SY-MSGNO)
* | [--->] IV_MSG_V1                      TYPE        SYMSGV (default =SY-MSGV1)
* | [--->] IV_MSG_V2                      TYPE        SYMSGV (default =SY-MSGV2)
* | [--->] IV_MSG_V3                      TYPE        SYMSGV (default =SY-MSGV3)
* | [--->] IV_MSG_V4                      TYPE        SYMSGV (default =SY-MSGV4)
* | [--->] IV_ERROR_CATEGORY              TYPE        /IWBEP/IF_MESSAGE_CONTAINER=>TY_ERROR_CATEGORY (default =/IWBEP/IF_MESSAGE_CONTAINER=>GCS_ERROR_CATEGORY-PROCESSING)
* | [--->] IV_IS_LEADING_MESSAGE          TYPE        ABAP_BOOL (default =ABAP_TRUE)
* | [--->] IV_ENTITY_TYPE                 TYPE        STRING(optional)
* | [--->] IT_KEY_TAB                     TYPE        /IWBEP/T_MGW_NAME_VALUE_PAIR(optional)
* | [--->] IV_ADD_TO_RESPONSE_HEADER      TYPE        /IWBEP/SUP_MC_ADD_TO_RESPONSE (default =ABAP_FALSE)
* | [--->] IV_MESSAGE_TARGET              TYPE        /IWBEP/SUP_MC_MESSAGE_TARGET(optional)
* | [!CX!] /IWBEP/CX_MGW_BUSI_EXCEPTION
* | [!CX!] /IWBEP/CX_MGW_TECH_EXCEPTION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD handle_exception.
*----------------------------------------------------------------------*
* Author          : Paul Landgrebe (Mindset) / PLANDGRE
* Creation Date   : 20 DEC 2017
* Technical design: Fiori Sales Enablement
* Description     : This method is a common routine to handle the
*                     raising of an exception base on messages from
*                     the parameters.
*----------------------------------------------------------------------*
* Modification Information
*----------------------------------------------------------------------*
* Date            : <DD-MMM-YYYY>
* Author          : <Name of the programmer/Programmer user ID>
* Change request  : <Change request number>
* Transport number: <Transport number>
* Description     : <Short description of changes>
*----------------------------------------------------------------------*

    DATA: lv_message       TYPE string.

    FIELD-SYMBOLS: <ls_return>  TYPE bapiret2.


    " If the global message container has been instanciated.
    IF go_msg_container IS BOUND.

      " If a message return table was provided...
      IF it_return[] IS NOT INITIAL.
        CALL METHOD go_msg_container->add_messages_from_bapi
          EXPORTING
            it_bapi_messages          = it_return
            iv_error_category         = iv_error_category
            iv_determine_leading_msg  = iv_determine_leading_msg
            iv_add_to_response_header = iv_add_to_response_header.


        " If the BAPI return structure is used...
      ELSEIF is_return IS NOT INITIAL.
        CALL METHOD go_msg_container->add_message_from_bapi
          EXPORTING
            is_bapi_message           = is_return
            iv_error_category         = iv_error_category
            iv_is_leading_message     = iv_is_leading_message
            iv_entity_type            = iv_entity_type
            it_key_tab                = it_key_tab
            iv_add_to_response_header = iv_add_to_response_header
            iv_message_target         = iv_message_target.


        " If an exception was passed...
      ELSEIF io_exception	IS BOUND.
        CALL METHOD go_msg_container->add_message_from_exception
          EXPORTING
            io_exception              = io_exception
            iv_error_category         = iv_error_category
            iv_is_leading_message     = iv_is_leading_message
            iv_entity_type            = iv_entity_type
            it_key_tab                = it_key_tab
            iv_add_to_response_header = iv_add_to_response_header
            iv_message_target         = iv_message_target.


        " If a message text string was specified...
      ELSEIF iv_msg_text IS NOT INITIAL
      OR     iv_msg_unlimited IS NOT INITIAL.

        CALL METHOD go_msg_container->add_message_text_only(
          EXPORTING
            iv_msg_type               = 'E'
            iv_msg_text               = iv_msg_text
            iv_add_to_response_header = iv_add_to_response_header
                                        ).

        " Use the specified message ID/No
      ELSE.
        CALL METHOD go_msg_container->add_message
          EXPORTING
            iv_msg_type               = iv_msg_type
            iv_msg_id                 = iv_msg_id
            iv_msg_number             = iv_msg_number
            iv_msg_v1                 = iv_msg_v1
            iv_msg_v2                 = iv_msg_v2
            iv_msg_v3                 = iv_msg_v3
            iv_msg_v4                 = iv_msg_v4
            iv_error_category         = iv_error_category
            iv_is_leading_message     = iv_is_leading_message
            iv_entity_type            = iv_entity_type
            it_key_tab                = it_key_tab
            iv_add_to_response_header = iv_add_to_response_header
            iv_message_target         = iv_message_target.
      ENDIF.

      "
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception  "busi_exception
        EXPORTING
*         textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message_unlimited = lv_message
          message_container = go_msg_container.

      " If the global message container has NOT been instanciated...
    ELSE.

      " Transfer the message text.
      IF iv_msg_text IS NOT INITIAL.
        lv_message = iv_msg_text.
      ELSE.
        lv_message = iv_msg_unlimited.
      ENDIF.

      "
      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception  "busi_exception
        EXPORTING
          textid            = /iwbep/cx_mgw_busi_exception=>business_error
          message_unlimited = lv_message.
*          PREVIOUS
*          MESSAGE_CONTAINER
*          HTTP_STATUS_CODE
*          HTTP_HEADER_PARAMETERS
*          SAP_NOTE_ID
*          MSG_CODE
*          ENTITY_TYPE
*          MESSAGE
*          MESSAGE_UNLIMITED
*          FILTER_PARAM
*          OPERATION_NO
    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_FIORI_GW->RETURN_ENTITYSET_COUNT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ENTITYSET                   TYPE        ANY TABLE
* | [<-->] CHS_RESPONSE_CONTEXT           TYPE        /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_CONTEXT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD return_entityset_count.

    DATA: lv_lines  TYPE i.


    " Tell the front-end how many records were read.
    DESCRIBE TABLE it_entityset LINES lv_lines.

    chs_response_context-inlinecount = lv_lines.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_FIORI_GW->SET_MESSAGE_CONTAINER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MSG_CONTAINER               TYPE REF TO /IWBEP/IF_MESSAGE_CONTAINER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD set_message_container.
*----------------------------------------------------------------------*
* Author          : Paul Landgrebe (Mindset) / PLANDGRE
* Creation Date   : 26 OCT 2017
* Technical design: Fiori Sales Enablement
* Description     : This method passes the message container from the
*                     GW class to the utility class for error handling.
*----------------------------------------------------------------------*
* Modification Information
*----------------------------------------------------------------------*
* Date            : <DD-MMM-YYYY>
* Author          : <Name of the programmer/Programmer user ID>
* Change request  : <Change request number>
* Transport number: <Transport number>
* Description     : <Short description of changes>
*----------------------------------------------------------------------*


    IF go_msg_container IS INITIAL.
      go_msg_container = iv_msg_container.
    ENDIF.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_FIORI_GW->SORT_GW_ENTITYSET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_TECH_REQUEST_CONTEXT        TYPE REF TO /IWBEP/IF_MGW_REQ_ENTITYSET
* | [--->] IS_DEFAULT                     TYPE        ABAP_SORTORDER(optional)
* | [<-->] CH_T_DATA                      TYPE        ANY TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD sort_gw_entityset.
*----------------------------------------------------------------------*
* Author          : Paul Landgrebe (Mindset) / PLANDGRE
* Creation Date   : 26 OCT 2017
* Technical design: Fiori Sales Enablement
* Description     : This method
*
*----------------------------------------------------------------------*
* Modification Information
*----------------------------------------------------------------------*
* Date            : <DD-MMM-YYYY>
* Author          : <Name of the programmer/Programmer user ID>
* Change request  : <Change request number>
* Transport number: <Transport number>
* Description     : <Short description of changes>
*----------------------------------------------------------------------*

    zcl_fiori_util=>sort_gw_entityset(
         EXPORTING io_tech_request_context = io_tech_request_context
                   is_default              = is_default
         CHANGING  ch_t_data               = ch_t_data ).

  ENDMETHOD.
ENDCLASS.