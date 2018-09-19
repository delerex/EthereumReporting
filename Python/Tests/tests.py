'''
created by Delerex.com
(c) 2018 Delerex Pte Ltd
'''


import json
import sys
from web3 import Web3
from datetime import datetime


contract_json_api_interface = "../../Solidity/dist/contracts/Reporting.json"
decimals=2



class Reporting_API:
    def FloatToDecimal(self, value):
        return int(value * 10 ** self.decimals)

    def DecimalToFloat(self, value):
        return float(value / 10 ** self.decimals)

    def __init__(self, accounts):
        self.company_name=""
        self.decimals=0
        self.units = ""
        self.parameters={}
        self.owner= ""
        self.date = datetime.min
        self.timestamp = 0
        self.dates=[]

        self.accounts = accounts
        json_data = open(contract_json_api_interface).read()
        contract_interface = json.loads(json_data)
        self.contract = w3.eth.contract(abi=contract_interface['abiDefinition'],
                                      address=contract_interface["deployedAddress"])
        self.company_name = self.get_company_name()
        self.decimals = self.get_decimals()
        self.units = self.get_units()


    def read(self):
        self.parameters = self.get_parameters()
        self.owner = self.get_owner_address()
        self.auditor = self.get_auditor_address()
        self.dates = self.get_dates()


    def print(self):
        print(f"Company name : {self.company_name}")
        print(f"Units        : {self.units}")
        print(f"Owner        : {self.owner}")
        print(f"Auditor      : {self.auditor}")
        print(f"Dates        : {self.dates}")
        print(f"Audited      : {self.get_audit_result()}")
        for i in self.parameters:
            print(f'{self.parameters[i].ljust(13," ")}: {self.get_value(i)}' )

    def get_parameters(self):
        res = {}
        parameters_count = self.contract.functions.getParametersCount().call()
        for i in range(0, parameters_count):
            p = self.contract.functions.getParameterId(i).call()
            res[p] = self.contract.functions.parameters(p).call()
        return res

    def get_dates(self):
        res = []
        dates_count = self.contract.functions.getDatesCount().call()
        for i in range(0, dates_count):
            res.append( datetime.fromtimestamp(self.contract.functions.getDate(i).call()) )
        return res


    def set_date(self, date):
        self.date = date
        self.timestamp = int(date.timestamp())

    def get_owner_address(self):
        return self.contract.functions.owner().call()

    def get_company_name(self):
        return self.contract.functions.company().call()

    def get_decimals(self):
        return self.contract.functions.decimals().call()

    def get_units(self):
        return self.contract.functions.units().call()

    def set_parameter(self, parameter_id, value):
        tx_hash = self.contract.functions.setParameter(parameter_id, value).transact({'gas': 100000})
        return tx_hash

    def get_parameter(self, parameter_id ):
        value = self.contract.functions.parameters(parameter_id).call()
        return value

    def set_value(self, parameter_id, value, date = None):
        if date is None:
            date = self.timestamp
        if isinstance(date, datetime):
            date = int(date.timestamp())
        intvalue = self.FloatToDecimal(value)
        tx_hash = self.contract.functions.setValue(date, parameter_id, intvalue).transact({'gas': 100000})
        return tx_hash

    def get_value(self, parameter_id, date = None ):
        if date is None:
            date = self.timestamp
        if isinstance(date, datetime):
            date = int(date.timestamp())
        value = self.contract.functions.values(date, parameter_id).call()
        return self.DecimalToFloat(value)

    def get_auditor_address(self):
        address = self.contract.functions.auditor().call()
        return address


    def set_auditor_address(self, address):
        tx_hash = self.contract.functions.setAuditor(address).transact({'gas': 100000})
        return tx_hash

    def get_audit_result(self, date = None):
        if date is None:
            date = self.timestamp
        if isinstance(date, datetime):
            date = int(date.timestamp())
        audit_result = self.contract.functions.audited(date).call()
        return audit_result


    def set_audit_result(self, approved, date = None):
        if date is None:
            date = self.timestamp
        if isinstance(date, datetime):
            date = int(date.timestamp())
        tx_hash = self.contract.functions.setAuditResult(date, approved).transact({'gas': 100000})
        return tx_hash



w3 = Web3( Web3.HTTPProvider("http://127.0.0.1:8545") )
print( w3.eth.accounts )


accounts = w3.eth.accounts
w3.eth.defaultAccount = w3.eth.accounts[0]

contract_api = Reporting_API(accounts)
contract_api.set_date( datetime(2018,1,1))
contract_api.set_parameter(0, "Cash" )
contract_api.set_parameter(1, "Liabilities" )
contract_api.set_value(0, 10293.2 )
contract_api.set_value(1, 3293.78 )
contract_api.read()
contract_api.print()

contract_api.set_auditor_address( w3.eth.accounts[1] )
w3.eth.defaultAccount = w3.eth.accounts[1]
contract_api.set_audit_result( True )

w3.eth.defaultAccount = w3.eth.accounts[0]
contract_api.read()
contract_api.print()


