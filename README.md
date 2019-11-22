# MTCDRelatedSourcesタグ

## 概要

あるコンテンツデータにおいて自身を参照しているコンテンツデータを取得するブロックタグ`MTCDRelatedSources`を提供します。

## 解説

コンテンツタイプAの商品セット1フィールドは、[コンテンツタイプフィールド](https://www.movabletype.jp/documentation/mt7/designers-guide/designing-content-type/available-field-types/content-type.html)でコンテンツタイプBの商品1を選択してリンクしているとします。  
この環境でコンテンツタイプBの商品1を出力する時に、コンテンツタイプBの商品1にリンクしているコンテンツタイプAのデータを出力可能にするタグを提供します。

### テンプレートタグ記述例

※コンテンツタイプAの名前は「商品セット(ID: 1)」、コンテンツタイプBの名前は「商品(ID: 2)」、コンテンツタイプAでコンテンツタイプBにリンクをするフィールドは「含まれる商品（ID: 30）」とします。

```
<mt:Contents content_type="商品">
  <mt:ContentsHeader><dl></mt:ContentsHeader>
    <mt:ContentID setvar="content_data_id" />
    <dt><mt:ContentLabel /></dt>
    <dd>
    <mt:CDRelatedSources field_name="含まれる商品" content_type_id="1" related_id="$content_data_id">
      <mt:If name="__first__"><ul></mt:If>
        <li><mt:ContentLabel /></li>
      <mt:If name="__last__"></ul></mt:If>
    </mt:CDRelatedSources>
    </dd>
  <mt:ContentsFooter></dl></mt:ContentsFooter>
</mt:Contents>
```
もしくは

```
<mt:Contents content_type="商品">
  <mt:ContentsHeader><dl></mt:ContentsHeader>
    <mt:ContentID setvar="content_data_id" />
    <dt><mt:ContentLabel /></dt>
    <dd>
    <mt:CDRelatedSources field_id="30" related_id="$content_data_id">
      <mt:If name="__first__"><ul></mt:If>
        <li><mt:ContentLabel /></li>
      <mt:If name="__last__"></ul></mt:If>
    </mt:CDRelatedSources>
    </dd>
  <mt:ContentsFooter></dl></mt:ContentsFooter>
</mt:Contents>
```
