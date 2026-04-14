<%!
/**
*  file: WNAnchor.jsp
*  subject: 페이징 처리를 하기 위한 정보처리클래스
*  ------------------------------------------------------------------------
*  @original author: WISEnut
*  @edit author:WISEnut
*  @update date 2012.02.03
*  ------------------------------------------------------------------------
*/
	public class WNAnchor {
        private int m_before = -1;
        private int m_next = -1;
        private int m_bundleBefore = -1;
        private int m_bundleNext = -1;
        private int m_firstPage = -1;
        private int m_lastPage = -1;
        private int m_totalPgCount = 0;
        private int m_totlalBundlePgCount = 0;
        private int m_pageCount = 0;
        private int m_curPageNumber = 1;
        private String[][] m_pages = new String[1][2];

        public WNAnchor() {
            m_pages[0][0] = "1";
            m_pages[0][1] = "-1";
        }

        public int getBefore() {
            return m_before;
        }

        public  void setBefore(int before) {
            m_before = before;
        }

        public int getFirstPage() {
            return m_firstPage;
        }

        public void setFirstPage(int firstPage) {
            m_firstPage = firstPage;
        }

        public int getLastPage() {
            return m_lastPage;
        }

        public void setLastPage(int lastPage) {
            m_lastPage = lastPage;
        }

        public int getNext() {
            return m_next;
        }

        public void setNext(int next) {
            m_next = next;
        }

        public int getBundleBefore() {
            return m_bundleBefore;
        }

        public void setBundleBefore(int bundleBefore) {
            m_bundleBefore = bundleBefore;
        }

        public int getBundleNext() {
            return m_bundleNext;
        }

        public void setBundleNext(int bundleNext) {
            m_bundleNext = bundleNext;
        }

        public int getTotalPgCount() {
            return m_totalPgCount;
        }

        public void setTotalPgCount(int totalPgCount) {
            m_totalPgCount = totalPgCount;
        }

        public int getTotlalBundlePgCount() {
            return m_totlalBundlePgCount;
        }

        public void setTotlalBundlePgCount(int totlalBundlePgCount) {
            m_totlalBundlePgCount = totlalBundlePgCount;
        }

        public int getPageCount() {
            return m_pageCount;
        }

        public void setPageCount(int pageCount) {
            m_pageCount = pageCount;
        }

        public int getCurPageNumber() {
            return m_curPageNumber;
        }

        public void setCurPageNumber(int curPageNumber) {
            m_curPageNumber = curPageNumber;
        }

        public String[][] getPages() {
            return m_pages;
        }

        public void setPages(String[][] pages) {
            m_pages = pages;
        }
    }
%>