package com.redhat.crowdfunding.service;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import org.web3j.abi.datatypes.Type;
import org.web3j.crypto.Credentials;

import com.redhat.crowdfunding.bean.Fund;
import com.redhat.crowdfunding.contract.CrowdFundingContract;
import com.redhat.crowdfunding.util.Consts;
import com.redhat.crowdfunding.util.Util;

/**
 * @author littleredhat
 */
public class CrowdFundingServiceImpl implements CrowdFundingService {

	private CrowdFundingContract contract;

	public CrowdFundingServiceImpl() {
		// ��ù���Աƾ֤
		Credentials credentials = Util.GetCredentials();
		if (credentials == null)
			return;
		// ��ȡ��Լ
		contract = Util.GetCrowdFundingContract(credentials, Consts.ADDR);
	}

	public CrowdFundingServiceImpl(String password, String content) {
		// ��÷�����ƾ֤
		Credentials credentials = Util.GetCredentials(password, content);
		if (credentials == null)
			return;
		// ��ȡ��Լ
		contract = Util.GetCrowdFundingContract(credentials, Consts.ADDR);
	}

	/**
	 * �ڳ��б�
	 * 
	 * @throws ExecutionException
	 * @throws InterruptedException
	 */
	public List<Fund> getFunds() throws InterruptedException, ExecutionException {
		List<Fund> fList = new ArrayList<Fund>();
		int count = contract.getFundCount().get().getValue().intValue();
		for (int i = 0; i < count; i++) {
			List<Type> info = contract.getFundInfo(i).get();
			Fund fund = new Fund();
			fund.setOwner(info.get(0).toString());
			fund.setNumber(Integer.parseInt(info.get(1).getValue().toString()));
			fund.setCoin(new BigInteger(info.get(2).getValue().toString()).divide(Consts.ETHER).intValue());
			fList.add(fund);
		}
		return fList;
	}

	/**
	 * �����ڳ�
	 * 
	 * @throws ExecutionException
	 * @throws InterruptedException
	 */
	public boolean raiseFund() throws InterruptedException, ExecutionException {
		if (contract != null) {
			boolean res = contract.isExist(contract.getContractAddress()).get().getValue();
			if (!res) { // ������
				contract.raiseFund();
				return true;
			}
		}
		return false;
	}

	/**
	 * ���ͽ��
	 * 
	 * @throws ExecutionException
	 * @throws InterruptedException
	 */
	public boolean sendCoin(String owner, int coin) throws InterruptedException, ExecutionException {
		if (contract != null) {
			boolean res = contract.isExist(owner).get().getValue();
			if (res) { // ����
				contract.sendCoin(owner, coin);
				return true;
			}
		}
		return false;
	}
}