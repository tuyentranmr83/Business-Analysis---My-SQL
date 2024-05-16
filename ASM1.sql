use mavenfuzzyfactory;

-- 1. Viết các truy vấn để cho thấy sự tăng trưởng về mặt số lượng trong website và đưa ra nhận xét

SELECT 	YEAR(website_sessions.created_at) as Yr,
		QUARTER(website_sessions.created_at) as Qtr,
        COUNT(DISTINCT website_sessions.website_session_id) as Sessions,
        COUNT(DISTINCT orders.order_id) as Orders

FROM website_sessions left join orders
	on website_sessions.website_session_id = orders.website_session_id

GROUP BY 1, 2;

-- Nhận xét:
-- Dựa vào kết quả truy vấn ta nhận thấy từ khi công ty A được thành lập vào quý 1 năm 2012 chúng ta có 1879 phiên truy cập vào website và nhận được 60 đơn hàng.
-- Sau đó công ty đã phát triển rất tốt điều đó thể hiện qua kết quả ghi nhận của quý thứ 2. Công ty đã có sự tăng trưởng nhảy vọt về cả phiên truy cập vào website là 11433 và nhận được 347 đơn hàng (tăng gần 6 lần).
-- So sánh các quý cùng kỳ trong các năm ta nhận thấy công ty A có sự tăng trưởng rất nhanh và giữ được sự ổn định theo chiều hướng tăng dần. Năm sau luôn cao hơn năm trước.
-- Tính cho đến chưa hết quý 1 năm 2015 tức là sau 3 năm thành lập công ty thì số lượng phiên truy cập vào website đã tăng lên tới con số 64198 (tăng gấp khoảng 34 lần so với khi bắt đầu thành lập công ty)
-- và số lượng đơn hàng đạt được 5420(tăng 90 lần).

-- 2. Viết các truy vấn để thể hiện hiện được hiệu quả hoạt động của công ty và đưa ra nhận xét

SELECT 	YEAR(website_sessions.created_at) as Yr,
		QUARTER(website_sessions.created_at) as Qtr,
        COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) as Session_to_order_cvr,
		AVG(orders.price_usd) as Revennue_per_order,
        SUM(orders.price_usd) / COUNT(DISTINCT website_sessions.website_session_id) as Revennue_per_session

FROM website_sessions left join orders
	on website_sessions.website_session_id = orders.website_session_id

GROUP BY 1, 2;

-- Nhận xét:
-- Dựa vào kết quả truy vấn ta nhận thấy công ty A đang hoạt động tương đối hiệu quả điều đó thể hiện qua tỷ lệ chuyển đổi từ tổng số phiên truy cập website thành số lượng đơn hàng.
-- Cụ thể vào năm đầu tiên ta có tỷ lệ chuyển đổi khoảng 3-4% sau đó tăng dần theo các năm và tính đến quý 1 năm 2015 thì tỷ lệ chuyển đổi đã tăng gấp 2 lên con số 8%.
-- Tính hiệu quả được tăng dần theo từng năm điều đó khiến cho doanh thu của công ty cũng được cải thiện theo chiều hướng tăng dần.
-- Cụ thể vào năm đầu tiên 2012 chúng ta đạt được doanh thu trung bình tính theo từng đơn hàng vào khoảng 49$/đơn hàng, khoảng 1,5$ cho 1 phiên truy cập.
-- thì tới quý 1 năm 2015 con số là khoảng 62$/đơn hàng, và 5,3$ cho 1 phiên truy cập vào website.

-- 3. Viết truy vấn để hiển thị sự phát triển của các đối tượng khác nhau và đưa ra nhận xét

SELECT 	YEAR(website_sessions.created_at) as Yr,
		QUARTER(website_sessions.created_at) as Qtr,
        Count(DISTINCT case when website_sessions.utm_source = 'gsearch' and website_sessions.utm_campaign = 'nonbrand' then orders.order_id else null end) as gsearch_nonbrand_orders,
		Count(DISTINCT case when website_sessions.utm_source = 'bsearch' and website_sessions.utm_campaign = 'nonbrand' then orders.order_id else null end) as bsearch_nonbrand_orders,
        Count(DISTINCT case when website_sessions.utm_campaign = 'brand' then orders.order_id else null end) as brand_search_orders,
        Count(DISTINCT case when website_sessions.utm_source is null and website_sessions.http_referer is not null then orders.order_id else null end) as organic_type_in_orders,
		Count(DISTINCT case when website_sessions.utm_source is null and website_sessions.http_referer is null then orders.order_id else null end) as direct_type_in_orders
       
FROM website_sessions left join orders
	on website_sessions.website_session_id = orders.website_session_id

GROUP BY 1,2;

-- Nhận xét
-- Chúng ta có thể nhận thấy đơn hàng của công ty đến từ nhiều kênh và nguồn khác nhau.
-- Gsearch và Nonband đang là 2 nguồn và kênh quảng cáo có trả phí đem lại số lượng đơn hàng lớn nhất cho công ty(chiếm khoảng 60%).
-- Số lượng đơn hàng của công ty tăng trưởng rất ổn định ở các chiến dịch quảng cáo có thu phí.
-- Bên cạnh đó các đơn hàng đến từ các nguồn trực tiếp hoặc gián tiếp cũng ổn định và tăng dần theo thời gian.

-- 4. Viết truy vấn để hiển thị tỷ lệ chuyển đổi phiên thành đơn đặt hàng cho các đối tượng đã viết ở yêu cầu 3 và đưa ra nhận xét

SELECT 	YEAR(website_sessions.created_at) as Yr,
		QUARTER(website_sessions.created_at) as Qtr,        
        Count(DISTINCT case when website_sessions.utm_source = 'gsearch' and website_sessions.utm_campaign = 'nonbrand' then orders.order_id else null end) / Count(DISTINCT case when website_sessions.utm_source = 'gsearch' and website_sessions.utm_campaign = 'nonbrand' then website_sessions.website_session_id else null end) as gsearch_nonbrand_conv_rt,
		Count(DISTINCT case when website_sessions.utm_source = 'bsearch' and website_sessions.utm_campaign = 'nonbrand' then orders.order_id else null end) / Count(DISTINCT case when website_sessions.utm_source = 'bsearch' and website_sessions.utm_campaign = 'nonbrand' then website_sessions.website_session_id else null end) as bsearch_nonbrand_conv_rt,
        Count(DISTINCT case when website_sessions.utm_campaign = 'brand' then orders.order_id else null end) / Count(DISTINCT case when website_sessions.utm_campaign = 'brand' then website_sessions.website_session_id else null end) as brand_search_conv_rt,
        Count(DISTINCT case when website_sessions.utm_source is null and website_sessions.http_referer is not null then orders.order_id else null end) / Count(DISTINCT case when website_sessions.utm_source is null and website_sessions.http_referer is not null then website_sessions.website_session_id else null end) as organic_type_conv_rt,
		Count(DISTINCT case when website_sessions.utm_source is null and website_sessions.http_referer is null then orders.order_id else null end) / Count(DISTINCT case when website_sessions.utm_source is null and website_sessions.http_referer is null then website_sessions.website_session_id else null end) as direct_type_conv_rt
       
FROM website_sessions left join orders
	on website_sessions.website_session_id = orders.website_session_id

GROUP BY 1,2;

-- Nhận xét
-- Ta nhận thấy tỷ lệ chuyển đổi số phiên truy cập vào website thành đơn hàng ở các nguồn khác nhau không có sự khác biệt đáng kể và đều có xu hướng tăng dần theo thời gian.
-- Điều này chứng tỏ công ty đang hoạt động hiệu quả và đang có sự tăng trưởng ổn định ở tất cả các kênh và nguồn khác nhau.
-- Tỷ lệ chuyển đổi cũng tăng trưởng theo hướng tăng dần theo thời gian, quý sau, năm sau luôn lớn hơn quý và năm của cùng kỳ năm ngoái.

-- 5. Viết truy vấn để thể hiện doanh thu và lợi nhuận theo sản phẩm, tổng doanh thu, tổng lợi nhuận của tất cả các sản phẩm

select 	Year(created_at) as yr,
		Month(created_at) as mth,
        sum(case when product_id = 1 then price_usd else null end) as mrfuzzy_rev,
        sum(case when product_id = 1 then price_usd else null end) - sum(case when product_id = 1 then cogs_usd else null end) as mrfuzzy_marg,
        sum(case when product_id = 2 then price_usd else null end) as lovebear_rev,
        sum(case when product_id = 2 then price_usd else null end) - sum(case when product_id = 2 then cogs_usd else null end) as lovebear_marg,
		sum(case when product_id = 3 then price_usd else null end) as birthdaybear_rev,
        sum(case when product_id = 3 then price_usd else null end) - sum(case when product_id = 3 then cogs_usd else null end) as birthdaybear_marg,
		sum(case when product_id = 4 then price_usd else null end) as minibear_rev,
        sum(case when product_id = 4 then price_usd else null end) - sum(case when product_id = 4 then cogs_usd else null end) as minibear_marg,
        sum(price_usd) as total_revenue,
        sum(price_usd - cogs_usd) as total_margin

from order_items
    
    group by 1,2
    ;

-- Nhận xét
-- Nhìn tổng quát thì công ty đang kinh doanh 4 sản phẩm chính và tất cả đều đang có doanh thu và lợi nhuận tăng trưởng tốt theo thời gian.(tháng sau luôn cao hơn tháng trước)
-- Nguồn doanh thu và lợi nhuận chính(nhiều nhất) đến từ những sản phẩm ra mắt trước sau đó giảm dần từ các sản phẩm ra mắt sau.
-- Điều này chứng tỏ các sản phẩm ra mắt trước đã và đang chiếm được 1 vị trí vững chắc trên thị trường, và các sản phẩm ra mắt sau cũng đang phát triển rất tốt.

-- 6. Viết truy vấn để tìm hiểu tác động của sản phẩm mới và đưa ra nhận xét

create temporary table session_product_created_at
select 	created_at,
		website_session_id,
        website_pageview_id
from website_pageviews
 
where pageview_url = '/products'
;

create temporary table session_to_next_product
select  session_product_created_at.created_at,
		session_product_created_at.website_session_id,
		MIN(website_pageviews.website_pageview_id) as click_to_next 

from session_product_created_at left join website_pageviews
	on session_product_created_at.website_session_id = website_pageviews.website_session_id
    and website_pageviews.website_pageview_id > session_product_created_at.website_pageview_id
group by 1, 2
;

select 	year(session_to_next_product.created_at) as yr,
		month(session_to_next_product.created_at) as mth,
		count(distinct session_to_next_product.website_session_id) as sessions_to_product_page,
        count(distinct click_to_next) as click_to_next,
        count(distinct click_to_next) / count(distinct session_to_next_product.website_session_id) as click_thought_rt,
        count(distinct orders.order_id) as orders,
        count(distinct orders.order_id) / count(distinct session_to_next_product.website_session_id) as product_to_order_rt
from 	session_to_next_product left join orders
		on session_to_next_product.website_session_id = orders.website_session_id

Group by 1, 2;

-- Nhận xét
-- Năm 2012 khi công ty mới thành lập và mới chỉ kinh doanh 1 sản phẩm là mrfuzzy thì có khoảng hơn 70% khách hàng sẽ không thoát phiên khi đang ở trang sản phẩm và có khoảng 8-9% trong số đó sẽ mua hàng.
-- Tháng 1 năm 2013 khi công ty ra mắt thêm sản phẩm mới lovebear thì có hơn 76% khách hàng sẽ bấm tiếp khi đang ở trang sản phẩm và có khoảng hơn 11% sẽ mua hàng.
-- Tháng 12 năm 2013 công ty tiếp tục ra mắt sản phẩm mới birthdaybear thì có đến 79% bấm tiếp và có gần 12% mua hàng.
-- Đến tháng 2 năm 2014 công ta ra mắt sản phẩm minibear thì có 81% bấm tiếp và có gần 13% mua hang.
-- Chúng ta có thể nhận thấy công ty ra mắt các sản phẩm mới khá thành công khi các sản phẩm mới luôn đem theo làn gió mới thúc đẩy khách hàng tìm kiếm và mua hàng nhiều hơn theo thời gian.

-- 7. Viết truy vấn thể hiện mức độ hiệu quả của các cặp sản phẩm được bán kèm và đưa ra nhận xét

Select 	
		orders.primary_product_id,
        count(distinct orders.order_id) as total_orders,
        count(case when order_items.product_id = 1 then order_items.product_id else null end) as _xsold_p1,
        count(case when order_items.product_id = 2 then order_items.product_id else null end) as _xsold_p2,
        count(case when order_items.product_id = 3 then order_items.product_id else null end) as _xsold_p3,
        count(case when order_items.product_id = 4 then order_items.product_id else null end) as _xsold_p4,
        count(case when order_items.product_id = 1 then order_items.product_id else null end) / count(distinct orders.order_id) as p1_xsell_rt,
        count(case when order_items.product_id = 2 then order_items.product_id else null end) / count(distinct orders.order_id) as p2_xsell_rt,
        count(case when order_items.product_id = 3 then order_items.product_id else null end) / count(distinct orders.order_id) as p3_xsell_rt,
        count(case when order_items.product_id = 4 then order_items.product_id else null end) / count(distinct orders.order_id) as p4_xsell_rt
    
From orders left join order_items
	on orders.order_id = order_items.order_id
    and order_items.is_primary_item = 0
    
Where orders.created_at > '2014-12-05'

Group by 1
  ;
  
-- Nhận xét
-- Kể từ 05/12/2014 khách hàng khi mua sản phẩm ID1, ID2, ID3 thì sản phẩm ID4 là sản phẩm bán kèm tốt nhất, còn khi khách hàng mua sang phẩm ID4 thì sản phẩm ID3 là sản phẩm bán kèm tốt nhất.
-- Chúng ta có thể nhận thấy các sản phẩm ra sau luôn có tỷ lệ bán kèm tốt hơn sản phẩm ra trước.
		
-- -------------------------------------------------
-- Nhận xét chung:
-- Qua tất cả các kết quả phân tích ở trên chung ta đã thấy rõ sự tăng trưởng và tính hiệu quả của công ty A qua các con số.
-- Tất cả từ các phiên truy cập, số đơn hàng, tỷ lệ chuyển đổi, doanh thu, lợi nhuận, ra mắt sản phẩm mới, sản phẩm bán kèm... luôn luôn tăng trưởng ổn định và tháng sau, quý sau, năm sau luôn tốt hơn các tháng, quý, năm cùng kỳ trước đó.
-- Các kết quả bên trên thể hiện công ty A đang có 1 đội ngũ nhân sự chất lượng và họ đang làm ngày 1 tốt hơn công việc của mình.
-- Lãnh đạo sáng suốt, nhân viên tốt và có trách nhiệm luôn là tài sản quý giá nhất của 1 công ty bền vững.

-- Đề xuất: Lợi nhuận của công ty đang đến chủ yếu từ nguồn gsearch và nonbrand(chiếm khoảng 60% trên tổng số lợi nhuận) vì vậy công ty có thể xem xét mở rộng thêm quy mô để tìm kiếm thêm khách hàng và gia tăng lợi nhuận.
-- Ngoài ra công ty có thể xem xét phát triển thêm các sản phẩm bán kèm, các chương trình chi ân khách hàng bằng các món quà khuyến mãi để thúc đẩy việc mua hàng nhiều hơn.