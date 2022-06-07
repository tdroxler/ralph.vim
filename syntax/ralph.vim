" Vim syntax file
" Language:     Ralph
"
"  Copy/paste from https://github.com/rust-lang/rust.vim/blob/2a6736852cbe64e2883adc70a427cb47cb3305bc/syntax/rust.vim
"  As Ralph as similar syntax as Rust

" Syntax definitions {{{1
" Basic keywords {{{2
syn keyword   ralphConditional match if else
syn keyword   ralphRepeat loop while
" `:syn match` must be used to prioritize highlighting `for` keyword.
syn match     ralphRepeat /\<for\>/
" Highlight `for` keyword in `impl ... for ... {}` statement. This line must
" be put after previous `syn match` line to overwrite it.
syn match     ralphKeyword /\%(\<impl\>.\+\)\@<=\<for\>/
syn keyword   ralphRepeat in
syn keyword   ralphTypedef type nextgroup=ralphIdentifier skipwhite skipempty
syn keyword   ralphStructure struct enum nextgroup=ralphIdentifier skipwhite skipempty
syn keyword   ralphUnion union nextgroup=ralphIdentifier skipwhite skipempty contained
syn match ralphUnionContextual /\<union\_s\+\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*/ transparent contains=ralphUnion
syn keyword   ralphOperator    as
syn keyword   ralphExistential existential nextgroup=ralphTypedef skipwhite skipempty contained
syn match ralphExistentialContextual /\<existential\_s\+type/ transparent contains=ralphExistential,ralphTypedef

syn match     ralphAssert      "\<assert\(\w\)*!" contained
syn match     ralphPanic       "\<panic\(\w\)*!" contained
syn match     ralphAsync       "\<async\%(\s\|\n\)\@="
syn keyword   ralphKeyword     break
syn keyword   ralphKeyword     box
syn keyword   ralphKeyword     continue
syn keyword   ralphKeyword     crate
syn keyword   ralphKeyword     extern nextgroup=ralphExternCrate,ralphObsoleteExternMod skipwhite skipempty
syn keyword   ralphKeyword     fn nextgroup=ralphFuncName skipwhite skipempty
syn keyword   ralphKeyword     impl let
syn keyword   ralphKeyword     macro
syn keyword   ralphKeyword     pub nextgroup=ralphPubScope skipwhite skipempty
syn keyword   ralphKeyword     return
syn keyword   ralphKeyword     yield
syn keyword   ralphSuper       super
syn keyword   ralphKeyword     where
syn keyword   ralphUnsafeKeyword unsafe
syn keyword   ralphKeyword     use nextgroup=ralphModPath skipwhite skipempty
" FIXME: Scoped impl's name is also fallen in this category
syn keyword   ralphKeyword     mod trait nextgroup=ralphIdentifier skipwhite skipempty
syn keyword   ralphStorage     move mut ref static const
syn match     ralphDefault     /\<default\ze\_s\+\(impl\|fn\|type\|const\)\>/
syn keyword   ralphAwait       await
syn match     ralphKeyword     /\<try\>!\@!/ display

syn keyword ralphPubScopeCrate crate contained
syn match ralphPubScopeDelim /[()]/ contained
syn match ralphPubScope /([^()]*)/ contained contains=ralphPubScopeDelim,ralphPubScopeCrate,ralphSuper,ralphModPath,ralphModPathSep,ralphSelf transparent

syn keyword   ralphExternCrate crate contained nextgroup=ralphIdentifier,ralphExternCrateString skipwhite skipempty
" This is to get the `bar` part of `extern crate "foo" as bar;` highlighting.
syn match   ralphExternCrateString /".*"\_s*as/ contained nextgroup=ralphIdentifier skipwhite transparent skipempty contains=ralphString,ralphOperator
syn keyword   ralphObsoleteExternMod mod contained nextgroup=ralphIdentifier skipwhite skipempty

syn match     ralphIdentifier  contains=ralphIdentifierPrime "\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained
syn match     ralphFuncName    "\%(r#\)\=\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*" display contained

syn region ralphMacroRepeat matchgroup=ralphMacroRepeatDelimiters start="$(" end="),\=[*+]" contains=TOP
syn match ralphMacroVariable "$\w\+"
syn match ralphRawIdent "\<r#\h\w*" contains=NONE

" Reserved (but not yet used) keywords {{{2
syn keyword   ralphReservedKeyword become do priv typeof unsized abstract virtual final override

" Built-in types {{{2
syn keyword   ralphType        isize usize char bool u8 u16 u32 u64 u128 f32
syn keyword   ralphType        f64 i8 i16 i32 i64 i128 str Self

" Things from the libstd v1 prelude (src/libstd/prelude/v1.rs) {{{2
" This section is just straight transformation of the contents of the prelude,
" to make it easy to update.

" Reexported core operators {{{3
syn keyword   ralphTrait       Copy Send Sized Sync
syn keyword   ralphTrait       Drop Fn FnMut FnOnce

" Reexported functions {{{3
" There’s no point in highlighting these; when one writes drop( or drop::< it
" gets the same highlighting anyway, and if someone writes `let drop = …;` we
" don’t really want *that* drop to be highlighted.
"syn keyword ralphFunction drop

" Reexported types and traits {{{3
syn keyword ralphTrait Box
syn keyword ralphTrait ToOwned
syn keyword ralphTrait Clone
syn keyword ralphTrait PartialEq PartialOrd Eq Ord
syn keyword ralphTrait AsRef AsMut Into From
syn keyword ralphTrait Default
syn keyword ralphTrait Iterator Extend IntoIterator
syn keyword ralphTrait DoubleEndedIterator ExactSizeIterator
syn keyword ralphEnum Option
syn keyword ralphEnumVariant Some None
syn keyword ralphEnum Result
syn keyword ralphEnumVariant Ok Err
syn keyword ralphTrait SliceConcatExt
syn keyword ralphTrait String ToString
syn keyword ralphTrait Vec

" Other syntax {{{2
syn keyword   ralphSelf        self
syn keyword   ralphBoolean     true false

" If foo::bar changes to foo.bar, change this ("::" to "\.").
" If foo::bar changes to Foo::bar, change this (first "\w" to "\u").
syn match     ralphModPath     "\w\(\w\)*::[^<]"he=e-3,me=e-3
syn match     ralphModPathSep  "::"

syn match     ralphFuncCall    "\w\(\w\)*("he=e-1,me=e-1
syn match     ralphFuncCall    "\w\(\w\)*::<"he=e-3,me=e-3 " foo::<T>();

" This is merely a convention; note also the use of [A-Z], restricting it to
" latin identifiers rather than the full Unicode uppercase. I have not used
" [:upper:] as it depends upon 'noignorecase'
"syn match     ralphCapsIdent    display "[A-Z]\w\(\w\)*"

syn match     ralphOperator     display "\%(+\|-\|/\|*\|=\|\^\|&\||\|!\|>\|<\|%\)=\?"
" This one isn't *quite* right, as we could have binary-& with a reference
syn match     ralphSigil        display /&\s\+[&~@*][^)= \t\r\n]/he=e-1,me=e-1
syn match     ralphSigil        display /[&~@*][^)= \t\r\n]/he=e-1,me=e-1
" This isn't actually correct; a closure with no arguments can be `|| { }`.
" Last, because the & in && isn't a sigil
syn match     ralphOperator     display "&&\|||"
" This is ralphArrowCharacter rather than ralphArrow for the sake of matchparen,
" so it skips the ->; see http://stackoverflow.com/a/30309949 for details.
syn match     ralphArrowCharacter display "->"
syn match     ralphQuestionMark display "?\([a-zA-Z]\+\)\@!"

syn match     ralphMacro       '\w\(\w\)*!' contains=ralphAssert,ralphPanic
syn match     ralphMacro       '#\w\(\w\)*' contains=ralphAssert,ralphPanic

syn match     ralphEscapeError   display contained /\\./
syn match     ralphEscape        display contained /\\\([nrt0\\'"]\|x\x\{2}\)/
syn match     ralphEscapeUnicode display contained /\\u{\%(\x_*\)\{1,6}}/
syn match     ralphStringContinuation display contained /\\\n\s*/
syn region    ralphString      matchgroup=ralphStringDelimiter start=+b"+ skip=+\\\\\|\\"+ end=+"+ contains=ralphEscape,ralphEscapeError,ralphStringContinuation
syn region    ralphString      matchgroup=ralphStringDelimiter start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=ralphEscape,ralphEscapeUnicode,ralphEscapeError,ralphStringContinuation,@Spell
syn region    ralphString      matchgroup=ralphStringDelimiter start='b\?r\z(#*\)"' end='"\z1' contains=@Spell

" Match attributes with either arbitrary syntax or special highlighting for
" derives. We still highlight strings and comments inside of the attribute.
syn region    ralphAttribute   start="#!\?\[" end="\]" contains=@ralphAttributeContents,ralphAttributeParenthesizedParens,ralphAttributeParenthesizedCurly,ralphAttributeParenthesizedBrackets,ralphDerive
syn region    ralphAttributeParenthesizedParens matchgroup=ralphAttribute start="\w\%(\w\)*("rs=e end=")"re=s transparent contained contains=ralphAttributeBalancedParens,@ralphAttributeContents
syn region    ralphAttributeParenthesizedCurly matchgroup=ralphAttribute start="\w\%(\w\)*{"rs=e end="}"re=s transparent contained contains=ralphAttributeBalancedCurly,@ralphAttributeContents
syn region    ralphAttributeParenthesizedBrackets matchgroup=ralphAttribute start="\w\%(\w\)*\["rs=e end="\]"re=s transparent contained contains=ralphAttributeBalancedBrackets,@ralphAttributeContents
syn region    ralphAttributeBalancedParens matchgroup=ralphAttribute start="("rs=e end=")"re=s transparent contained contains=ralphAttributeBalancedParens,@ralphAttributeContents
syn region    ralphAttributeBalancedCurly matchgroup=ralphAttribute start="{"rs=e end="}"re=s transparent contained contains=ralphAttributeBalancedCurly,@ralphAttributeContents
syn region    ralphAttributeBalancedBrackets matchgroup=ralphAttribute start="\["rs=e end="\]"re=s transparent contained contains=ralphAttributeBalancedBrackets,@ralphAttributeContents
syn cluster   ralphAttributeContents contains=ralphString,ralphCommentLine,ralphCommentBlock,ralphCommentLineDocError,ralphCommentBlockDocError
syn region    ralphDerive      start="derive(" end=")" contained contains=ralphDeriveTrait
" This list comes from src/libsyntax/ext/deriving/mod.rs
" Some are deprecated (Encodable, Decodable) or to be removed after a new snapshot (Show).
syn keyword   ralphDeriveTrait contained Clone Hash RalphcEncodable RalphcDecodable Encodable Decodable PartialEq Eq PartialOrd Ord Rand Show Debug Default FromPrimitive Send Sync Copy

" dyn keyword: It's only a keyword when used inside a type expression, so
" we make effort here to highlight it only when Ralph identifiers follow it
" (not minding the case of pre-2018 Ralph where a path starting with :: can
" follow).
"
" This is so that uses of dyn variable names such as in 'let &dyn = &2'
" and 'let dyn = 2' will not get highlighted as a keyword.
syn match     ralphKeyword "\<dyn\ze\_s\+\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)" contains=ralphDynKeyword
syn keyword   ralphDynKeyword  dyn contained

" Number literals
syn match     ralphDecNumber   display "\<[0-9][0-9_]*\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
syn match     ralphHexNumber   display "\<0x[a-fA-F0-9_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
syn match     ralphOctNumber   display "\<0o[0-7_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="
syn match     ralphBinNumber   display "\<0b[01_]\+\%([iu]\%(size\|8\|16\|32\|64\|128\)\)\="

" Special case for numbers of the form "1." which are float literals, unless followed by
" an identifier, which makes them integer literals with a method call or field access,
" or by another ".", which makes them integer literals followed by the ".." token.
" (This must go first so the others take precedence.)
syn match     ralphFloat       display "\<[0-9][0-9_]*\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\|\.\)\@!"
" To mark a number as a normal float, it must have at least one of the three things integral values don't have:
" a decimal point and more numbers; an exponent; and a type suffix.
syn match     ralphFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)\="
syn match     ralphFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\(f32\|f64\)\="
syn match     ralphFloat       display "\<[0-9][0-9_]*\%(\.[0-9][0-9_]*\)\=\%([eE][+-]\=[0-9_]\+\)\=\(f32\|f64\)"

" For the benefit of delimitMate
syn region ralphLifetimeCandidate display start=/&'\%(\([^'\\]\|\\\(['nrt0\\\"]\|x\x\{2}\|u{\%(\x_*\)\{1,6}}\)\)'\)\@!/ end=/[[:cntrl:][:space:][:punct:]]\@=\|$/ contains=ralphSigil,ralphLifetime
syn region ralphGenericRegion display start=/<\%('\|[^[:cntrl:][:space:][:punct:]]\)\@=')\S\@=/ end=/>/ contains=ralphGenericLifetimeCandidate
syn region ralphGenericLifetimeCandidate display start=/\%(<\|,\s*\)\@<='/ end=/[[:cntrl:][:space:][:punct:]]\@=\|$/ contains=ralphSigil,ralphLifetime

"ralphLifetime must appear before ralphCharacter, or chars will get the lifetime highlighting
syn match     ralphLifetime    display "\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*"
syn match     ralphLabel       display "\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*:"
syn match     ralphLabel       display "\%(\<\%(break\|continue\)\s*\)\@<=\'\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*"
syn match   ralphCharacterInvalid   display contained /b\?'\zs[\n\r\t']\ze'/
" The groups negated here add up to 0-255 but nothing else (they do not seem to go beyond ASCII).
syn match   ralphCharacterInvalidUnicode   display contained /b'\zs[^[:cntrl:][:graph:][:alnum:][:space:]]\ze'/
syn match   ralphCharacter   /b'\([^\\]\|\\\(.\|x\x\{2}\)\)'/ contains=ralphEscape,ralphEscapeError,ralphCharacterInvalid,ralphCharacterInvalidUnicode
syn match   ralphCharacter   /'\([^\\]\|\\\(.\|x\x\{2}\|u{\%(\x_*\)\{1,6}}\)\)'/ contains=ralphEscape,ralphEscapeUnicode,ralphEscapeError,ralphCharacterInvalid

syn match ralphShebang /\%^#![^[].*/
syn region ralphCommentLine                                                  start="//"                      end="$"   contains=ralphTodo,@Spell
syn region ralphCommentLineDoc                                               start="//\%(//\@!\|!\)"         end="$"   contains=ralphTodo,@Spell
syn region ralphCommentLineDocError                                          start="//\%(//\@!\|!\)"         end="$"   contains=ralphTodo,@Spell contained
syn region ralphCommentBlock             matchgroup=ralphCommentBlock         start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/" contains=ralphTodo,ralphCommentBlockNest,@Spell
syn region ralphCommentBlockDoc          matchgroup=ralphCommentBlockDoc      start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=ralphTodo,ralphCommentBlockDocNest,ralphCommentBlockDocRalphCode,@Spell
syn region ralphCommentBlockDocError     matchgroup=ralphCommentBlockDocError start="/\*\%(!\|\*[*/]\@!\)"    end="\*/" contains=ralphTodo,ralphCommentBlockDocNestError,@Spell contained
syn region ralphCommentBlockNest         matchgroup=ralphCommentBlock         start="/\*"                     end="\*/" contains=ralphTodo,ralphCommentBlockNest,@Spell contained transparent
syn region ralphCommentBlockDocNest      matchgroup=ralphCommentBlockDoc      start="/\*"                     end="\*/" contains=ralphTodo,ralphCommentBlockDocNest,@Spell contained transparent
syn region ralphCommentBlockDocNestError matchgroup=ralphCommentBlockDocError start="/\*"                     end="\*/" contains=ralphTodo,ralphCommentBlockDocNestError,@Spell contained transparent

" FIXME: this is a really ugly and not fully correct implementation. Most
" importantly, a case like ``/* */*`` should have the final ``*`` not being in
" a comment, but in practice at present it leaves comments open two levels
" deep. But as long as you stay away from that particular case, I *believe*
" the highlighting is correct. Due to the way Vim's syntax engine works
" (greedy for start matches, unlike Ralph's tokeniser which is searching for
" the earliest-starting match, start or end), I believe this cannot be solved.
" Oh you who would fix it, don't bother with things like duplicating the Block
" rules and putting ``\*\@<!`` at the start of them; it makes it worse, as
" then you must deal with cases like ``/*/**/*/``. And don't try making it
" worse with ``\%(/\@<!\*\)\@<!``, either...

syn keyword ralphTodo contained TODO FIXME XXX NB NOTE SAFETY

" asm! macro {{{2
syn region ralphAsmMacro matchgroup=ralphMacro start="\<asm!\s*(" end=")" contains=ralphAsmDirSpec,ralphAsmSym,ralphAsmConst,ralphAsmOptionsGroup,ralphComment.*,ralphString.*

" Clobbered registers
syn keyword ralphAsmDirSpec in out lateout inout inlateout contained nextgroup=ralphAsmReg skipwhite skipempty
syn region  ralphAsmReg start="(" end=")" contained contains=ralphString

" Symbol operands
syn keyword ralphAsmSym sym contained nextgroup=ralphAsmSymPath skipwhite skipempty
syn region  ralphAsmSymPath start="\S" end=",\|)"me=s-1 contained contains=ralphComment.*,ralphIdentifier

" Const
syn region  ralphAsmConstBalancedParens start="("ms=s+1 end=")" contained contains=@ralphAsmConstExpr
syn cluster ralphAsmConstExpr contains=ralphComment.*,ralph.*Number,ralphString,ralphAsmConstBalancedParens
syn region  ralphAsmConst start="const" end=",\|)"me=s-1 contained contains=ralphStorage,@ralphAsmConstExpr

" Options
syn region  ralphAsmOptionsGroup start="options\s*(" end=")" contained contains=ralphAsmOptions,ralphAsmOptionsKey
syn keyword ralphAsmOptionsKey options contained
syn keyword ralphAsmOptions pure nomem readonly preserves_flags noreturn nostack att_syntax contained

" Folding rules {{{2
" Trivial folding rules to begin with.
" FIXME: use the AST to make really good folding
syn region ralphFoldBraces start="{" end="}" transparent fold

if !exists("b:current_syntax_embed")
    let b:current_syntax_embed = 1
    syntax include @RalphCodeInComment <sfile>:p:h/ralph.vim
    unlet b:current_syntax_embed

    " Currently regions marked as ```<some-other-syntax> will not get
    " highlighted at all. In the future, we can do as vim-markdown does and
    " highlight with the other syntax. But for now, let's make sure we find
    " the closing block marker, because the rules below won't catch it.
    syn region ralphCommentLinesDocNonRalphCode matchgroup=ralphCommentDocCodeFence start='^\z(\s*//[!/]\s*```\).\+$' end='^\z1$' keepend contains=ralphCommentLineDoc

    " We borrow the rules from ralph’s src/libralphdoc/html/markdown.rs, so that
    " we only highlight as Ralph what it would perceive as Ralph (almost; it’s
    " possible to trick it if you try hard, and indented code blocks aren’t
    " supported because Markdown is a menace to parse and only mad dogs and
    " Englishmen would try to handle that case correctly in this syntax file).
    syn region ralphCommentLinesDocRalphCode matchgroup=ralphCommentDocCodeFence start='^\z(\s*//[!/]\s*```\)[^A-Za-z0-9_-]*\%(\%(should_panic\|no_run\|ignore\|allow_fail\|ralph\|test_harness\|compile_fail\|E\d\{4}\|edition201[58]\)\%([^A-Za-z0-9_-]\+\|$\)\)*$' end='^\z1$' keepend contains=@RalphCodeInComment,ralphCommentLineDocLeader
    syn region ralphCommentBlockDocRalphCode matchgroup=ralphCommentDocCodeFence start='^\z(\%(\s*\*\)\?\s*```\)[^A-Za-z0-9_-]*\%(\%(should_panic\|no_run\|ignore\|allow_fail\|ralph\|test_harness\|compile_fail\|E\d\{4}\|edition201[58]\)\%([^A-Za-z0-9_-]\+\|$\)\)*$' end='^\z1$' keepend contains=@RalphCodeInComment,ralphCommentBlockDocStar
    " Strictly, this may or may not be correct; this code, for example, would
    " mishighlight:
    "
    "     /**
    "     ```ralph
    "     println!("{}", 1
    "     * 1);
    "     ```
    "     */
    "
    " … but I don’t care. Balance of probability, and all that.
    syn match ralphCommentBlockDocStar /^\s*\*\s\?/ contained
    syn match ralphCommentLineDocLeader "^\s*//\%(//\@!\|!\)" contained
endif

" Default highlighting {{{1
hi def link ralphDecNumber       ralphNumber
hi def link ralphHexNumber       ralphNumber
hi def link ralphOctNumber       ralphNumber
hi def link ralphBinNumber       ralphNumber
hi def link ralphIdentifierPrime ralphIdentifier
hi def link ralphTrait           ralphType
hi def link ralphDeriveTrait     ralphTrait

hi def link ralphMacroRepeatDelimiters   Macro
hi def link ralphMacroVariable Define
hi def link ralphSigil         StorageClass
hi def link ralphEscape        Special
hi def link ralphEscapeUnicode ralphEscape
hi def link ralphEscapeError   Error
hi def link ralphStringContinuation Special
hi def link ralphString        String
hi def link ralphStringDelimiter String
hi def link ralphCharacterInvalid Error
hi def link ralphCharacterInvalidUnicode ralphCharacterInvalid
hi def link ralphCharacter     Character
hi def link ralphNumber        Number
hi def link ralphBoolean       Boolean
hi def link ralphEnum          ralphType
hi def link ralphEnumVariant   ralphConstant
hi def link ralphConstant      Constant
hi def link ralphSelf          Constant
hi def link ralphFloat         Float
hi def link ralphArrowCharacter ralphOperator
hi def link ralphOperator      Operator
hi def link ralphKeyword       Keyword
hi def link ralphDynKeyword    ralphKeyword
hi def link ralphTypedef       Keyword " More precise is Typedef, but it doesn't feel right for Ralph
hi def link ralphStructure     Keyword " More precise is Structure
hi def link ralphUnion         ralphStructure
hi def link ralphExistential   ralphKeyword
hi def link ralphPubScopeDelim Delimiter
hi def link ralphPubScopeCrate ralphKeyword
hi def link ralphSuper         ralphKeyword
hi def link ralphUnsafeKeyword Exception
hi def link ralphReservedKeyword Error
hi def link ralphRepeat        Conditional
hi def link ralphConditional   Conditional
hi def link ralphIdentifier    Identifier
hi def link ralphCapsIdent     ralphIdentifier
hi def link ralphModPath       Include
hi def link ralphModPathSep    Delimiter
hi def link ralphFunction      Function
hi def link ralphFuncName      Function
hi def link ralphFuncCall      Function
hi def link ralphShebang       Comment
hi def link ralphCommentLine   Comment
hi def link ralphCommentLineDoc SpecialComment
hi def link ralphCommentLineDocLeader ralphCommentLineDoc
hi def link ralphCommentLineDocError Error
hi def link ralphCommentBlock  ralphCommentLine
hi def link ralphCommentBlockDoc ralphCommentLineDoc
hi def link ralphCommentBlockDocStar ralphCommentBlockDoc
hi def link ralphCommentBlockDocError Error
hi def link ralphCommentDocCodeFence ralphCommentLineDoc
hi def link ralphAssert        PreCondit
hi def link ralphPanic         PreCondit
hi def link ralphMacro         Macro
hi def link ralphType          Type
hi def link ralphTodo          Todo
hi def link ralphAttribute     PreProc
hi def link ralphDerive        PreProc
hi def link ralphDefault       StorageClass
hi def link ralphStorage       StorageClass
hi def link ralphObsoleteStorage Error
hi def link ralphLifetime      Special
hi def link ralphLabel         Label
hi def link ralphExternCrate   ralphKeyword
hi def link ralphObsoleteExternMod Error
hi def link ralphQuestionMark  Special
hi def link ralphAsync         ralphKeyword
hi def link ralphAwait         ralphKeyword
hi def link ralphAsmDirSpec    ralphKeyword
hi def link ralphAsmSym        ralphKeyword
hi def link ralphAsmOptions    ralphKeyword
hi def link ralphAsmOptionsKey ralphAttribute

" Other Suggestions:
" hi ralphAttribute ctermfg=cyan
" hi ralphDerive ctermfg=cyan
" hi ralphAssert ctermfg=yellow
" hi ralphPanic ctermfg=red
" hi ralphMacro ctermfg=magenta

syn sync minlines=200
syn sync maxlines=500

let b:current_syntax = "ralph"

" vim: set et sw=4 sts=4 ts=8:
