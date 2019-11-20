# CDRelatedSourceタグ

コンテンツタイプAの商品セット1で、コンテンツタイプBの商品1を選択してリンクしています。  
また、コンテンツタイプAの商品セット2で、コンテンツタイプBの商品1を選択してリンクしています。  
この時、コンテンツタイプBの商品1にリンクされているコンテンツタイプAを取得することができるタグを提供します。

※コンテンツタイプAの名前は「商品セット(ID: 1)」、コンテンツタイプBの名前は「商品(ID: 2)」、コンテンツタイプAでコンテンツタイプBにリンクをするフィールドは「含まれる商品（ID: 30）」とします。

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
