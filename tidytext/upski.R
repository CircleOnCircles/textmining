# R version 3.6.3 (2020-02-29) -- "Holding the Windsock"
# RStudio Version 1.2.5042


# library and packages
library(tidyverse)
library(jsonlite)

# load data
file(load = "upski.RData")


# read JSON data
json_data <- fromJSON("april.json", flatten = TRUE)
json_data2 <- fromJSON("april.json", flatten = FALSE)   # subtle difference

# this is a list
# note: aside from 'posts' other columns are either list of one or not informative
# note: pageUrL suggest the entirety of 'posts' came from one FB page
json_data$posts

# list converted to a character (not advised)
posts <- as.character(json_data$posts)

# list converted to data.frame (recommended)
# note: some cells contain other lists or variables
# note: postImages, postLinks and postsUrl contain data about a specific FB job-listing post
posts_df <- as.data.frame(json_data$posts)

# These 4 columns: postStats.comments, postStats.reactions, postStats.shares, postComments.count
# indicate how "popular/engaging" a ROW in posts_df dataframe is.
# NOTE: each ROW is a post for a Job Position (there are 187 Rows or Job Position posted)
# includes description of job and of the FB post itself 
# (# reactions, # comments, # shares)


############# EXPLORATORY DATA ANALYSIS ################

# arranged desc order postStats.reactions - top 23 are *not* job posts, but posting of screen shots (humor, thought provoking)
# screen shot of pantip or twitter (@BFkumkom)
View(posts_df %>% arrange(desc(postStats.reactions)))

# arrange desc order postStats.comments - 50/50 job posts & screen shots
# top 10 job posts include: online gamer, lazada (inventory mgmt), online fiction writer, online teaching, thai post office
# tesco lotus (operations), farmhouse, audio engineer / sound mix, 
# cross-posting: parttime pantip
View(posts_df %>% arrange(desc(postStats.comments)))
View(posts_df %>% arrange(desc(postComments.count)))


# arrange desc order postStats.shares
# only 2 job posting in top twenty; rest screen shots similar to 'reactions'
View(posts_df %>% arrange(desc(postStats.shares)))

########### Specific Word Search #############
# 'Part Time' (24)
# 'Full Time' (7)
# 'Pizza' (9) // 6 = Pizza Company, 2 = Domino's, 1 = Call Center
# 'Lazada' (3)
# 'Call Center' (5)
# 'Kerry Express' (4)
# 'Grab Bike' (1)
# 'Tesco Lotus' (3)
# 'KFC' (2)
# 'พนักงานปฏิบัติการ' (Tesco) (1)
# 'ออนไลน์' (23) (apply online)
# 'Admin' (6) 
# 'แอดมิน' (11)
# 'Office' (4)
# 'Content' (1)
# 'นักแปล' (1)
# 'แม่บ้าน' (6)
# 'ประจำร้าน' (15)
# '10,000' (8) *10,000 bht salary in range
# '11,000' (5) *11,000 bht salary in range
# '13,000' (9) *13,000 bht salary in range
# '15,000' (37) *15,000 bht salary in range
# '18,000' (9) *18,000 bht salary in range
# '20,000' (15) *20,000 bht salary in range
# '30,000' (12) *30,000 bht salary in range
# '40,000' (1) *40,000 bht salary in range
# 'อายุ 25' (9)
# 'คอมมิชชั่น' (8)
# 'Commission' (4)
# 'แพ็คสินค้า' (5)
# 'จีน' (5)
# 'ร้านซักรีด' (1)
# 'Telesales' (4)
# 'ประกันสังคม' (social benefit) (23)
# '📍' (96) 
# 'วุฒิ ม.3' (19)
# 'สาขา' (38) Retail
# 'ร้าน' (40) Retail
# 'พนักงานประจำร้าน' (13) Retail
# 'ร้านอาหาร' (restaurant) (6)
# 'ไลฟ์สด' (Video Jockey) (5)
# 'อาหาร' (20)
# 'ช่าง' (6) (handy man)

#### Qualitications
posts_df_qual <- posts_df %>% filter(grepl('คุณสมบัติ', postText))
# arranged roughly by engagement (comments, reactions, then shares)
View(posts_df_qual %>% arrange(desc(postStats.comments, postStats.reactions, postStats.shares)))
# 'คุณสมบัติ' (104) (qualifications)
# 'อายุ 18 ปี ขึ้นไป' (3)
# 'อายุ 25-40' (1)
# 'ภาษาอังกฤษ' (14)


# Example specific text search
View(posts_df %>% filter(grepl('Pizza', postText)))
View(posts_df %>% filter(grepl('Lazada', postText)))
View(posts_df %>% filter(grepl('ออนไลน์', postText)))
View(posts_df %>% filter(grepl('แม่บ้าน', postText)))
View(posts_df %>% filter(grepl('ประจำร้าน', postText)))
View(posts_df %>% filter(grepl('11,000', postText)))
View(posts_df %>% filter(grepl('อายุ 25', postText)))
View(posts_df %>% filter(grepl('ประกันสังคม', postText)))
View(posts_df %>% filter(grepl('📍', postText)))   
View(posts_df %>% filter(grepl('วุฒิ ม.3', postText)))
View(posts_df %>% filter(grepl('สาขา', postText)))
View(posts_df %>% filter(grepl('อาหาร', postText)))


#### Top 30 Job Posting by *Number_of_Comments
## non-traditional jobs descriptions: นักเล่นเกมส์, นักเขียนนิยายออนไลน์, แคสออนไลน์,
## ผู้เข้าร่วมทดสอบเกม, งานอัดเสียงที่บ้าน, สอนภาษาจีนออนไลน์, เปิดแคสติ้งออนไลน์, รับสมัครแม่บ้านออนไลน์ 
View(posts_df %>% arrange(desc(postStats.comments)))





# 24 of 187 includes "Part Time"
View(filter(posts_df, grepl('Part Time', postText)))

# same filter through dplyr (24 of 187 includes "Part Time")
View(posts_df %>% filter(grepl('Part Time', postText)))

####### 24 'Part Time' job posts arranged in descending order by reactions (can repeat for comments, shares)
View(posts_df %>% filter(grepl('Part Time', postText)) %>% arrange(desc(postStats.reactions)))





# actual comments to each posting
# filtered by 'RECENT_ACTIVITY' (newest) - response to each posting
# ERROR: argument imply differing number of rows (i.e., each posts getting different number of actual comments)
# SOLUTION: manual - go through each of 187 one-by-one to convert to dataframe

comments_post_1 <- as.data.frame(posts_df$postComments.comments[1])

#### summary of basic search terms ######
# a sense of the job market, on this specific FB page
# 187 postings
# 30 are screen shots (non-job posts)
# 157 job posts
# 104 job posts provide qualifications

# 71 job posts provide salary data ('รายได้')

# all job posts have a leading-emoji (NOTE: following is filter by leading-emoji)

# 💻 / 🖥 (25): (computer job and skill-related) 
#  - (Admin & Office worker) (12) พนักงานแอดมิน, พนักงานแอดมินเพจ, Admin ประจำออฟฟิศ, ตอบลูกค้า Online, ตอบเเชทลูกค้า, แอดมินตอบแชท , แอดมินผู้ช่วย, Admin
#  - ทำงานที่ Office เท่านั้น, เลขานุการ, ผู้ช่วยเลขา, ใช้โซเชียล และโปรแกรม MS Word,Excel 
#  - ตำแหน่ง Programmer, ใช้งานบนเว็บ, เจ้าหน้าที่คีย์ข้อมูล (2), 
#  - นักเขียนนิยายออนไลน์, สออนไลน์,
#  - ร่วมทดสอบเกม, นักเล่นเกมส์ 
#  - คนทำ Content กราฟฟิก

# 📦 (17): (product inventory-related) แพ็คสินค้า, คลังสินค้า, ส่งสินค้า, คัดแยกสินค้า, บัญชีนับสต็อก
# 🚗 / 👚 / 👕 / 💄 / 📱 (14): (sales rep) นายหน้าขายรถยนต์, ขายเสื้อผ้าไทย, รับสมัครคนไลฟ์สด ขายเสื้อผ้า, พนักงานขายแบรนด์เครื่องสำอาง, พนักงานบริการลูกค้า ประจำ Shop Dtac , พนักงานติดฟิล์มมือถือ, ตัวแทนขาย
# ขายเครื่องใช้ไฟฟ้า, ตัวแทนจำหน่าย,  ตัวแทนขายอิสระ, พนักงานขาย, พนักงานขายประจำร้าน, พนักงานขาย
# 🛵 (11): (delivery / driver) ส่งอาหาร, ส่งพัสดุ, พนักงานไบค์เกอร์, พนักงานขับรถ, พนักงานขับรถจักรยานยนต์, ผู้ขับมอเตอร์ไซค์, Rider, Driver, Grab Bike, GoBike, ขับรถจักรยานยนต์
# 📞 (9): (call center) Call Center, Telesales (others indicate phone number)


# 🔧 (4): (handy man) ช่างซ่อมอินเตอร์เอไอเอสไฟเบอร์ (2), ช่างแอร์ และผู้ช่วยช่าง (2)
# 🧕 (6): (maid) รับสมัครแม่บ้าน, สมัครเเม่บ้าน 
# 🎙 / 🎤  (3): (VJ) ไลฟ์สดผ่านมือถือ, วีเจออนไลน์,  สมัครวีเจ
# 🇨🇳 (3): (Chinese related) ผู้จัดการร้านอาหารจีน, ครูสอนภาษาจีนออนไลน์, ผู้ช่วยผู้จัดการร้านอาหารจีน

# 🎬 (1): (online casting) เปิดแคสติ้งออนไลน์
# 🎧 (1): (sound technician) งานอัดเสียงที่บ้าน 
# 📝 (1): (clerk) เขียนงานลงในเอกสาร
# 🏴󠁧󠁢󠁥󠁮󠁧󠁿 (1): (interpreter) สมัครล่ามและนักแปลภาษาอังกฤษ 


### Food & Beverage ### (36)
# ☕ (8) (coffee): พนักงานบาริสต้า (6), ประจำร้านกาแฟ, 
# 🥤 (8): (tea) พนักงานประจำร้านชา (5), ทำเครื่องดื่ม/เซอร์วิส, 
# 🧁 / 🥙 / 🥦  / 🍢 / 🍞 / 🍙 / 🥧 (11): (staff at smaller shops) พนักงานร้านขนมหวาน, พนักงานขาย ร้านน้อยเบเกอรี่, พนักงานประจำ ร้าน Subway, พนักงานคลังสินค้าผักผลไม้, 
# พนักงานขายหม่าล่า, Farmhouse พนักงาน , สมัครพนักงาน ร้านศุภชัยซาลาเปา, ผู้ช่วยขายขนมแพนเค้ก, พนักงานร้านอาหาร, พนักงานเสิร์ฟรายวัน, พนักงานประจำร้านโรตี, ประจำร้านคาเฟ่
# 🍕 (5): (pizza) พนักงานทำอาหาร (Cook) (2), พนักงานส่งอาหาร (Driver), ขับรถส่งพิซซ่า, บริการหน้าร้าน, ขับรถส่งพิซซ่า
# 🏪 /🍓 (5): (retail) Tesco Lotus Express รับสมัครพนักงาน, พนักงานประจำร้าน 7-11, พนักงานประจำร้าน Baimiang Healthy Shop, พนักงานประจำร้าน, พนักงาน PC ร้าน
# 🍗 (2): (KFC) พนักงานประจำร้าน (cashier, cook), พนักงานรับรายการอาหาร

# 🍲 (3): (chef / cook)ผู้ช่วยพ่อครัว (chef/cook) สมัครแม่ครัว, พนักงานทำอาหารญี่ปุ่น
# (1): (store manager) ผู้จัดการร้าน,


# 📢 / 🔻 (4): Miscellaneous: (fund raiser) อาสาระดมทุน, (coordinator) เจ้าหน้าที่ประสานงาน, ประจำร้านซักรีด, พนักงานผลิตสินค้า
# 👩  (1): Influencer
# 💸 (1): Part-time ฝ่าย Operation
# 📭 (1): ไปรษณีย์ไทย (พนักงานขับรถ, พนักงานลำเลียง)
# 🏊 (1): คน ดูแลสระว่ายน้ำสโมสรหมู่บ้าน
