!function(t){"object"==typeof exports&&"object"==typeof module?t(require("codemirror")):"function"==typeof define&&define.amd?define(["codemirror"],t):t(CodeMirror)}(function(t){"use strict";function i(t,i){this.cm=t,this.options=i,this.widget=null,this.debounce=0,this.tick=0,this.startPos=this.cm.getCursor("start"),this.startLen=this.cm.getLine(this.startPos.line).length-this.cm.getSelection().length;var e=this;t.on("cursorActivity",this.activityFunc=function(){e.cursorActivity()})}function e(t,i,e){var n=t.options.hintOptions,o={};for(var s in d)o[s]=d[s];if(n)for(var s in n)void 0!==n[s]&&(o[s]=n[s]);if(e)for(var s in e)void 0!==e[s]&&(o[s]=e[s]);return o.hint.resolve&&(o.hint=o.hint.resolve(t,i)),o}function n(t){return"string"==typeof t?t:t.text}function o(t,i){function e(t,e){var o;o="string"!=typeof e?function(t){return e(t,i)}:n.hasOwnProperty(e)?n[e]:e,s[t]=o}var n={Up:function(){i.moveFocus(-1)},Down:function(){i.moveFocus(1)},PageUp:function(){i.moveFocus(-i.menuSize()+1,!0)},PageDown:function(){i.moveFocus(i.menuSize()-1,!0)},Home:function(){i.setFocus(0)},End:function(){i.setFocus(i.length-1)},Enter:i.pick,Tab:i.pick,Esc:i.close},o=t.options.customKeys,s=o?{}:n;if(o)for(var c in o)o.hasOwnProperty(c)&&e(c,o[c]);var r=t.options.extraKeys;if(r)for(var c in r)r.hasOwnProperty(c)&&e(c,r[c]);return s}function s(t,i){for(;i&&i!=t;){if("LI"===i.nodeName.toUpperCase()&&i.parentNode==t)return i;i=i.parentNode}}function c(i,e){this.completion=i,this.data=e,this.picked=!1;var c=this,r=i.cm,h=this.hints=document.createElement("ul");h.className="CodeMirror-hints",this.selectedHint=e.selectedHint||0;for(var u=e.list,f=0;f<u.length;++f){var d=h.appendChild(document.createElement("li")),p=u[f],m=l+(f!=this.selectedHint?"":" "+a);null!=p.className&&(m=p.className+" "+m),d.className=m,p.render?p.render(d,e,p):d.appendChild(document.createTextNode(p.displayText||n(p))),d.hintId=f}var g=r.cursorCoords(i.options.alignWithWord?e.from:null),v=g.left,y=g.bottom,w=!0;h.style.left=v+"px",h.style.top=y+"px";var k=window.innerWidth||Math.max(document.body.offsetWidth,document.documentElement.offsetWidth),H=window.innerHeight||Math.max(document.body.offsetHeight,document.documentElement.offsetHeight);(i.options.container||document.body).appendChild(h);var C=h.getBoundingClientRect(),b=C.bottom-H;if(b>0){var A=C.bottom-C.top,x=g.top-(g.bottom-C.top);if(x-A>0)h.style.top=(y=g.top-A)+"px",w=!1;else if(A>H){h.style.height=H-5+"px",h.style.top=(y=g.bottom-C.top)+"px";var S=r.getCursor();e.from.ch!=S.ch&&(g=r.cursorCoords(S),h.style.left=(v=g.left)+"px",C=h.getBoundingClientRect())}}var T=C.right-k;if(T>0&&(C.right-C.left>k&&(h.style.width=k-5+"px",T-=C.right-C.left-k),h.style.left=(v=g.left-T)+"px"),r.addKeyMap(this.keyMap=o(i,{moveFocus:function(t,i){c.changeActive(c.selectedHint+t,i)},setFocus:function(t){c.changeActive(t)},menuSize:function(){return c.screenAmount()},length:u.length,close:function(){i.close()},pick:function(){c.pick()},data:e})),i.options.closeOnUnfocus){var M;r.on("blur",this.onBlur=function(){M=setTimeout(function(){i.close()},100)}),r.on("focus",this.onFocus=function(){clearTimeout(M)})}var F=r.getScrollInfo();return r.on("scroll",this.onScroll=function(){var t=r.getScrollInfo(),e=r.getWrapperElement().getBoundingClientRect(),n=y+F.top-t.top,o=n-(window.pageYOffset||(document.documentElement||document.body).scrollTop);return w||(o+=h.offsetHeight),o<=e.top||o>=e.bottom?i.close():(h.style.top=n+"px",void(h.style.left=v+F.left-t.left+"px"))}),t.on(h,"dblclick",function(t){var i=s(h,t.target||t.srcElement);i&&null!=i.hintId&&(c.changeActive(i.hintId),c.pick())}),t.on(h,"click",function(t){var e=s(h,t.target||t.srcElement);e&&null!=e.hintId&&(c.changeActive(e.hintId),i.options.completeOnSingleClick&&c.pick())}),t.on(h,"mousedown",function(){setTimeout(function(){r.focus()},20)}),t.signal(e,"select",u[0],h.firstChild),!0}function r(t,i){if(!t.somethingSelected())return i;for(var e=[],n=0;n<i.length;n++)i[n].supportsSelection&&e.push(i[n]);return e}function h(i,e){var n,o=i.getHelpers(e,"hint");if(o.length){for(var s,c=!1,h=0;h<o.length;h++)o[h].async&&(c=!0);return c?(s=function(t,i,e){function n(o,c){if(o==s.length)return i(null);var r=s[o];if(r.async)r(t,function(t){t?i(t):n(o+1)},e);else{var c=r(t,e);c?i(c):n(o+1)}}var s=r(t,o);n(0)},s.async=!0):s=function(t,i){for(var e=r(t,o),n=0;n<e.length;n++){var s=e[n](t,i);if(s&&s.list.length)return s}},s.supportsSelection=!0,s}return(n=i.getHelper(i.getCursor(),"hintWords"))?function(i){return t.hint.fromList(i,{words:n})}:t.hint.anyword?function(i,e){return t.hint.anyword(i,e)}:function(){}}var l="CodeMirror-hint",a="CodeMirror-hint-active";t.showHint=function(t,i,e){if(!i)return t.showHint(e);e&&e.async&&(i.async=!0);var n={hint:i};if(e)for(var o in e)n[o]=e[o];return t.showHint(n)},t.defineExtension("showHint",function(n){n=e(this,this.getCursor("start"),n);var o=this.listSelections();if(!(o.length>1)){if(this.somethingSelected()){if(!n.hint.supportsSelection)return;for(var s=0;s<o.length;s++)if(o[s].head.line!=o[s].anchor.line)return}this.state.completionActive&&this.state.completionActive.close();var c=this.state.completionActive=new i(this,n);c.options.hint&&(t.signal(this,"startCompletion",this),c.update(!0))}});var u=window.requestAnimationFrame||function(t){return setTimeout(t,1e3/60)},f=window.cancelAnimationFrame||clearTimeout;i.prototype={close:function(){this.active()&&(this.cm.state.completionActive=null,this.tick=null,this.cm.off("cursorActivity",this.activityFunc),this.widget&&this.data&&t.signal(this.data,"close"),this.widget&&this.widget.close(),t.signal(this.cm,"endCompletion",this.cm))},active:function(){return this.cm.state.completionActive==this},pick:function(i,e){var o=i.list[e];o.hint?o.hint(this.cm,i,o):this.cm.replaceRange(n(o),o.from||i.from,o.to||i.to,"complete"),t.signal(i,"pick",o),this.close()},cursorActivity:function(){this.debounce&&(f(this.debounce),this.debounce=0);var t=this.cm.getCursor(),i=this.cm.getLine(t.line);if(t.line!=this.startPos.line||i.length-t.ch!=this.startLen-this.startPos.ch||t.ch<this.startPos.ch||this.cm.somethingSelected()||t.ch&&this.options.closeCharacters.test(i.charAt(t.ch-1)))this.close();else{var e=this;this.debounce=u(function(){e.update()}),this.widget&&this.widget.disable()}},update:function(t){if(null!=this.tick)if(this.options.hint.async){var i=++this.tick,e=this;this.options.hint(this.cm,function(n){e.tick==i&&e.finishUpdate(n,t)},this.options)}else this.finishUpdate(this.options.hint(this.cm,this.options),t)},finishUpdate:function(i,e){this.data&&t.signal(this.data,"update"),i&&this.data&&t.cmpPos(i.from,this.data.from)&&(i=null),this.data=i;var n=this.widget&&this.widget.picked||e&&this.options.completeSingle;this.widget&&this.widget.close(),i&&i.list.length&&(n&&1==i.list.length?this.pick(i,0):(this.widget=new c(this,i),t.signal(i,"shown")))}},c.prototype={close:function(){if(this.completion.widget==this){this.completion.widget=null,this.hints.parentNode.removeChild(this.hints),this.completion.cm.removeKeyMap(this.keyMap);var t=this.completion.cm;this.completion.options.closeOnUnfocus&&(t.off("blur",this.onBlur),t.off("focus",this.onFocus)),t.off("scroll",this.onScroll)}},disable:function(){this.completion.cm.removeKeyMap(this.keyMap);var t=this;this.keyMap={Enter:function(){t.picked=!0}},this.completion.cm.addKeyMap(this.keyMap)},pick:function(){this.completion.pick(this.data,this.selectedHint)},changeActive:function(i,e){if(i>=this.data.list.length?i=e?this.data.list.length-1:0:0>i&&(i=e?0:this.data.list.length-1),this.selectedHint!=i){var n=this.hints.childNodes[this.selectedHint];n.className=n.className.replace(" "+a,""),n=this.hints.childNodes[this.selectedHint=i],n.className+=" "+a,n.offsetTop<this.hints.scrollTop?this.hints.scrollTop=n.offsetTop-3:n.offsetTop+n.offsetHeight>this.hints.scrollTop+this.hints.clientHeight&&(this.hints.scrollTop=n.offsetTop+n.offsetHeight-this.hints.clientHeight+3),t.signal(this.data,"select",this.data.list[this.selectedHint],n)}},screenAmount:function(){return Math.floor(this.hints.clientHeight/this.hints.firstChild.offsetHeight)||1}},t.registerHelper("hint","auto",{resolve:h}),t.registerHelper("hint","fromList",function(i,e){var n=i.getCursor(),o=i.getTokenAt(n),s=t.Pos(n.line,o.end);if(o.string&&/\w/.test(o.string[o.string.length-1]))var c=o.string,r=t.Pos(n.line,o.start);else var c="",r=s;for(var h=[],l=0;l<e.words.length;l++){var a=e.words[l];a.slice(0,c.length)==c&&h.push(a)}return h.length?{list:h,from:r,to:s}:void 0}),t.commands.autocomplete=t.showHint;var d={hint:t.hint.auto,completeSingle:!0,alignWithWord:!0,closeCharacters:/[\s()\[\]{};:>,]/,closeOnUnfocus:!0,completeOnSingleClick:!1,container:null,customKeys:null,extraKeys:null};t.defineOption("hintOptions",null)});