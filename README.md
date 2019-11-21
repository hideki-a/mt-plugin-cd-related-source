# CDRelatedSourceタグ

## 概要

あるコンテンツデータにおいて自身を参照しているコンテンツデータのIDを取得するタグを提供します。

## 解説

コンテンツタイプAの商品セット1フィールドは[コンテンツタイプフィールド](https://www.movabletype.jp/documentation/mt7/designers-guide/designing-content-type/available-field-types/content-type.html)で、コンテンツタイプBの商品1を選択してリンクしています。  
この時、コンテンツタイプBの商品1を参照しているコンテンツタイプAのデータを取得することができるタグを提供します。

※コンテンツタイプAの名前は「商品セット(ID: 1)」、コンテンツタイプBの名前は「商品(ID: 2)」、コンテンツタイプAでコンテンツタイプBにリンクをするフィールドは「含まれる商品（ID: 30）」とします。

### テンプレートタグ記述例

```
<mt:Contents content_type="商品">
  <mt:ContentsHeader><ul></mt:ContentsHeader>
    <li><mt:ContentID setvar="cd_id" /><mt:ContentLabel escape />にリンクしているのはコンテンツタイプAの次のIDです: <mt:CDRelatedSource field_name="含まれる商品" content_type_id="1" related_id="$cd_id" /></li>
  <mt:ContentsFooter></ul></mt:ContentsFooter>
</mt:Contents>
```
もしくは

```
<mt:Contents content_type="商品">
  <mt:ContentsHeader><ul></mt:ContentsHeader>
    <li><mt:ContentID setvar="cd_id" /><mt:ContentLabel escape />にリンクしているのはコンテンツタイプAの次のIDです: <mt:CDRelatedSource field_id="30" related_id="$cd_id" /></li>
  <mt:ContentsFooter></ul></mt:ContentsFooter>
</mt:Contents>
```

IDが取得できたら、以下のようにIDを指定してリンク元のコンテンツタイプのデータを取得します。

```
<mt:CDRelatedSource field_id="30" related_id="$cd_id" setvar="source_id" />
<mt:Contents content_type="商品セット" id="$source_id"><mt:ContentLabel /></mt:Contents>
```

なお、コンテンツフィールドで複数選択が可能な場合は、`MTCDRelatedSource`の返値がIDのカンマ区切りとなります。  
[GetHashVarプラグイン](https://github.com/alfasado/mt-plugin-get-hash-var)を利用してカンマ区切りの文字列を配列に変換して処理を行います。

```
<mt:Contents content_type="商品">
  <mt:ContentsHeader><ul></mt:ContentsHeader>
    <li><mt:ContentID setvar="cd_id" /><mt:ContentLabel />
    <mt:CDRelatedSource field_name="含まれる商品" content_type_id="6" related_id="$cd_id" setvar="source_ids" />
    <mt:SplitVar name="source_ids" glue="," />
    <mt:Loop name="source_ids">
      <mt:If name="__first__"><ul></mt:If>
        <li><mt:Contents content_type="商品セット" id="$__value__"><mt:ContentLabel /></mt:Contents></li>
      <mt:If name="__last__"></ul></mt:If>
    </mt:Loop>
    </li>
  <mt:ContentsFooter></ul></mt:ContentsFooter>
</mt:Contents>
```
