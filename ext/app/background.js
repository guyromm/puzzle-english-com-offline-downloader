import qs from 'qs';
const l = console.log;
const PG='http://localhost:3000/'
console.log('bg');

async function doNext(tabId) {
    browser.tabs.sendMessage(tabId,
			     {message:'goto',
			      url:await nextUncollected()});
    
}
async function nextUncollected() {
    let res = await fetch(PG+'lessons?'+qs.stringify({contents_ts:'is.null'}));
    let j = await res.json();
    if (j.length)
	return j[0].url;
}
browser.runtime.onMessage.addListener(
    async function(m,sender) {
	let {message,url} = m;
	l('message arrived',message,'from',url);
	switch (message) {
	case 'contents':
	    const body = {contents:m.body,
			  contents_ts:new Date()
			 };
	    l('body=',body);
	    let pres = await fetch(
		PG+'lessons?'+qs.stringify({url:'eq.'+url.split('?')[0]}),
		{method:'PATCH',
		 headers:{'Content-Type':'application/json'},
		 body:JSON.stringify(body)
		}
	    );
	    l('patch res',pres);
	    doNext(sender.tab.id);	    
	    break;
	case 'details':
	    m.title
	    url,
	    m.videoDownloadLink
	    let dres = await fetch(PG+'lessons?'+qs.stringify({url:'eq.'+url}),
							   {method:'PATCH',
							    headers:{'Content-Type':'application/json'},
							    body:JSON.stringify({title:m.title,
										 video_download_url:m.videoDownloadLink})});
	    l('dres=',dres);
	    break;
	case 'am-at':
	    let res = await fetch(PG+'lessons?'+qs.stringify({url:'eq.'+url.split('?')[0]}));
	    let j = await res.json();
	    l('res',j);
	    let gotoNext=false;
	    if (j.length){
		const p = j[0];
		if (p.contents_ts && p.title && p.video_download_url)
		    gotoNext=true;
		else
		    browser.tabs.sendMessage(sender.tab.id,
					     {message:'scrape-in-place',
					      url:url});
	    }
	    else
		gotoNext=true;
	    if (gotoNext)
		doNext(sender.tab.id);


	    break;
	}
    });
