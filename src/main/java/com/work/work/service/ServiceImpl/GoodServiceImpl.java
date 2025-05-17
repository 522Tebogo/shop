package com.work.work.service.ServiceImpl;

import com.work.work.entity.Goods;
import com.work.work.mapper.GoodMapper;
import com.work.work.service.GoodService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class GoodServiceImpl implements GoodService {

    private static final Logger logger = LoggerFactory.getLogger(GoodServiceImpl.class); // 日志

    @Autowired
    GoodMapper goodMapper;

    @Override
    public List<Goods> getActiveGoods() {
        return goodMapper.getActiveGoods();
    }

    @Override
    public List<Goods> getRandomGoods() {
        return goodMapper.getRandomGoods();
    }

    @Override
    public Goods getGoodById(int goodid) {
        return goodMapper.getGoodById(goodid);
    }

    @Override
    public List<Goods> getAllGoods() {
        return goodMapper.getAllGoods();
    }
    @Override
    public List<Goods> getGoodsByCategory(String category) {
        return goodMapper.getGoodsByCategory(category);
    }

    @Override // 从接口移除了 public，这里可以保留或移除
    public List<Goods> selectAll() {
        return goodMapper.selectAll(); // 假设 GoodMapper 有这个方法
    }
    @Override // 从接口移除了 public
    public List<Goods> selectHot(){
        return goodMapper.selectHot(); // 假设 GoodMapper 有这个方法
    }
    @Override
    public List<Goods> findByPage(int page, int pageSize,String word) {
        int offset = (page - 1) * pageSize;
        return goodMapper.selectByPage(offset, pageSize,word );
    }
    @Override
    public long count(String word) {
        return goodMapper.count(word);
    }

    @Override
    @Transactional // 建议对写操作添加事务管理
    public boolean saveGoods(Goods goods) {
        try {
            int result = goodMapper.insertGoods(goods);
            return result > 0;
        } catch (Exception e) {
            logger.error("Error saving goods: {}", goods.getName(), e);
            return false;
        }
    }

    @Override
    @Transactional // 建议对写操作添加事务管理
    public boolean deleteGoodsById(int goodId) {
        try {
            // 可选：删除前检查商品是否存在
            Goods existingGoods = goodMapper.getGoodById(goodId);
            if (existingGoods == null) {
                logger.warn("Attempted to delete non-existent goods with ID: {}", goodId);
                return false; // 或者抛出特定异常
            }
            // 可选：如果商品有关联的图片文件，可能需要在这里添加删除文件的逻辑
            // String imagePath = existingGoods.getImageUrl(); // 或 getImage()
            // if (imagePath != null && !imagePath.isEmpty()) {
            //     try {
            //         Path pathToDelete = Paths.get(goodsUploadDirGlobal + imagePath.replaceFirst("/uploads/goods/", "")); // 需要全局的上传目录路径
            //         Files.deleteIfExists(pathToDelete);
            //         logger.info("Deleted image file for goods ID {}: {}", goodId, pathToDelete);
            //     } catch (IOException e) {
            //         logger.error("Error deleting image file {} for goods ID {}", imagePath, goodId, e);
            //     }
            // }

            int result = goodMapper.deleteGoodsById(goodId);
            if (result > 0) {
                logger.info("Successfully deleted goods with ID: {}", goodId);
                return true;
            } else {
                logger.warn("Failed to delete goods with ID: {} (no rows affected, or goods not found)", goodId);
                return false; // 可能商品在检查后被删除，或者数据库操作未影响任何行
            }
        } catch (Exception e) {
            logger.error("Error deleting goods with ID: {}", goodId, e);
            // 可以考虑向上抛出自定义的业务异常
            return false;
        }
    }

    @Override
    public int getCountById(int goodid) {
        return goodMapper.getCountById(goodid);
    }

    @Override
    public int plusCount(int goodid, int num) {
        return goodMapper.plusCount(goodid, num);
    }

    @Override
    public int minusCount(int goodid, int num) {
        return goodMapper.minusCount(goodid, num);
    }

    @Override
    public int getCountByDoubleId(int userId, int goodId) {
        return goodMapper.getCountByDoubleId(userId,goodId);
    }



    @Override
    public int getCountByTripleId(int userId, int goodId, long orderCode) {
        return goodMapper.getCountByTripleId(userId,goodId,orderCode);
    }

    @Override
    public int changeCount(int goodid, int num) {
        return goodMapper.changeCount(goodid,num);
    }

    @Override
    public int getOutByGoodId(int goodid) {
        return goodMapper.getOutByGoodId(goodid);
    }

}