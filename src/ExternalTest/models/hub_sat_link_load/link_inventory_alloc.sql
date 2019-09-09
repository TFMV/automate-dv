{{config(materialized='incremental', schema ='VLT', enabled=true, tags=['static', 'incremental'])}}

{%- set src_table = ['SRC_TEST_STG.STG_PART',
                     'SRC_TEST_STG.STG_PARTSUPP',
                     'SRC_TEST_STG.STG_LINEITEM']
                                                                                      -%}
{%- set src_cols = ['INVENTORY_ALLOCATION_PK',
                    'PART_PK', 'SUPPLIER_PK', 'LINEITEM_PK',
                    'LOADDATE', 'SOURCE']                                             -%}

{%- set src_pk = ['INVENTORY_ALLOCATION_PK',
                  'INVENTORY_ALLOCATION_PK',
                  'INVENTORY_ALLOCATION_PK']                                          -%}

{%- set src_fk = ['PART_PK', 'SUPPLIER_PK', 'LINEITEM_PK']                            -%}
{%- set src_source = 'SOURCE'                                                         -%}
{%- set src_ldts = 'LOADDATE'                                                         -%}

{%- set tgt_pk = ['INVENTORY_ALLOCATION_PK', 'BINARY(16)', 'INVENTORY_ALLOCATION_PK'] -%}
{%- set tgt_fk = [['PART_PK', 'BINARY(16)', 'PART_PK'],
                  ['SUPPLIER_PK', 'BINARY(16)', 'SUPPLIER_PK'],
                  ['LINEITEM_PK', 'BINARY(16)', 'LINEITEM_PK']]                       -%}

{%- set tgt_ldts = ['LOADDATE', 'DATE', 'LOADDATE']                                   -%}
{%- set tgt_source = ['SOURCE', 'VARCHAR(4)', 'SOURCE']                               -%}

{%- set hash_model = ref('stg_orders_hashed')                                         -%}

{{ snow_vault.link_template(src_table, src_cols, src_pk, src_fk, src_ldts, src_source,
                           tgt_pk, tgt_fk, tgt_ldts, tgt_source, hash_model) }}